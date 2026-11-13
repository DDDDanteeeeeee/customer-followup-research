#!/usr/bin/env python3
"""Read customer-related records from local Odoo via XML-RPC.

Auto-detects Odoo on common ports. Requires database credentials for full read.
Outputs JSON with opportunities (crm.lead) and sale orders matching customer name.
"""
import json
import sys
import argparse
from xmlrpc.client import ServerProxy

COMMON_PORTS = [8069, 8070, 4780, 4797, 4792]


def detect_odoo():
    for port in COMMON_PORTS:
        url = f"http://127.0.0.1:{port}"
        try:
            common = ServerProxy(f"{url}/xmlrpc/2/common", allow_none=True)
            version = common.version()
            if version and "server_version" in version:
                return url, version["server_version"]
        except Exception:
            continue
    return None, None


def search_records(db, uid, key, models, domain, fields, url, limit=20):
    models_proxy = ServerProxy(f"{url}/xmlrpc/2/object", allow_none=True)
    results = {}
    for model in models:
        try:
            ids = models_proxy.execute_kw(db, uid, key, model, "search", [domain], {"limit": limit})
            if ids:
                records = models_proxy.execute_kw(db, uid, key, model, "read", [ids], {"fields": fields})
                results[model] = records
            else:
                results[model] = []
        except Exception as e:
            results[model] = [{"error": str(e)}]
    return results


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--customer", required=True, help="Customer name to search")
    parser.add_argument("--host", default="auto", help="Odoo URL (default: auto-detect)")
    parser.add_argument("--db", default="", help="Database name")
    parser.add_argument("--user", default="", help="Username or email")
    parser.add_argument("--key", default="", help="API key")
    args = parser.parse_args()

    host = args.host
    if host == "auto":
        host, version = detect_odoo()
        if not host:
            print(json.dumps({"status": "not_found", "message": "No Odoo detected on common ports."}))
            return

    if not args.db or not args.user or not args.key:
        print(json.dumps({
            "status": "needs_credentials",
            "host": host,
            "message": f"Odoo at {host} requires --db, --user, --key (generate in Odoo: Settings > Users > API Keys)."
        }))
        return

    common = ServerProxy(f"{host}/xmlrpc/2/common", allow_none=True)
    uid = common.authenticate(args.db, args.user, args.key, {})
    if not uid:
        print(json.dumps({"status": "auth_failed", "message": "Authentication failed."}))
        return

    domain = [("partner_id", "ilike", f"%{args.customer}%")]
    records = search_records(
        args.db, uid, args.key,
        ["crm.lead", "sale.order"],
        domain,
        {
            "crm.lead": ["name", "partner_id", "stage_id", "expected_revenue", "date_deadline", "user_id"],
            "sale.order": ["name", "partner_id", "amount_total", "state", "date_order"],
        },
        host,
    )

    print(json.dumps({
        "status": "ok",
        "host": host,
        "customer": args.customer,
        "opportunities": records.get("crm.lead", []),
        "sale_orders": records.get("sale.order", []),
    }, ensure_ascii=False, indent=2))


if __name__ == "__main__":
    main()
