# MiroFish-CRE — Vertical PropTech Layer

This directory contains CRE-specific additions to MiroFish — all AGPL-3.0 licensed,
consistent with the upstream fork.

## Structure

- `personas/` — CRE persona templates (7 clusters: Operators, VC, Competitors, Channel, Gatekeepers, Regulators, Influencers)
- `ontology/` — PropTech entity schema for GraphRAG grounding (Company, Product, Buyer, Investor, Regulation, Market, Technology, Transaction, Asset)
- `regulatory/` — GCC regulatory knowledge base (DLD, RERA, GCGRA, NEOM specs)
- `api/` — REST API wrapper for Cairn Intelligence Platform integration (HTTP boundary)

## Architecture

MiroFish-CRE runs as a containerised service. The Cairn Intelligence Platform
communicates with it exclusively over HTTP REST — no shared code, no shared imports.
This is the AGPL/proprietary firewall as described in NOTICE.md.

## Status

Phase 1 — Fork & Pin: ✅ Complete (2026-04-17)
Phase 2 — CRE Persona Library: ⏳ Queued (PS-7 sprint)
Phase 3 — GCC Regulatory Knowledge Base: ⏳ Queued (PS-7 sprint)
Phase 4 — REST API + Docker Compose: ⏳ Queued (PS-7 sprint)
Phase 5 — First OASIS Simulation: ⏳ Queued (PS-7 sprint)
