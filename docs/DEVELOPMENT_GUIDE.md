# Information Center Development Guide v1.0

## Purpose

This document defines the engineering process used to develop new
features for the Information Center. It describes **how features are
designed, implemented, validated, and frozen**. It is intended to ensure
consistency, maintainability, and predictable development across all
future plugins.

------------------------------------------------------------------------

# Development Lifecycle

## Phase 1 -- Requirements

Define the feature from the user's perspective.

-   Describe the desired behavior.
-   Avoid implementation details.
-   Do not write code.

Deliverable: - Behavior statement

------------------------------------------------------------------------

## Phase 2 -- Platform Research

Before writing code:

-   Review the official Qt documentation.
-   Review the official Quickshell documentation.
-   Review the operating system APIs and capabilities.
-   Verify compatibility with supported platforms.

Current project targets:

-   NixOS 26.05
-   Hyprland 0.55.4
-   Fedora 44
-   KDE Plasma 6.7

Goals:

-   Never invent functionality that already exists.
-   Prefer supported APIs over custom implementations.
-   Avoid deprecated or legacy interfaces.

Deliverable: - Research summary

------------------------------------------------------------------------

## Phase 3 -- Framework Review

Review the existing Information Center architecture.

Questions:

-   Does a Provider already exist?
-   Does a Controller already exist?
-   Does a Manager already exist?
-   Can this feature extend an existing subsystem?

Principle:

> Reuse before creating.

Deliverable: - Integration plan

------------------------------------------------------------------------

## Phase 4 -- Architecture

Define responsibilities.

Every layer must answer:

-   What is my responsibility?
-   What is not my responsibility?

Example:

    Provider
        ↓
    Controller
        ↓
    Manager
        ↓
    Presentation

Deliverable: - Architecture diagram

------------------------------------------------------------------------

## Phase 5 -- Interface Contracts

Define communication between layers.

Freeze:

-   Exported properties
-   Signals
-   Public functions

Do not implement yet.

Deliverable: - API specification

------------------------------------------------------------------------

## Phase 6 -- Specification

Write the complete feature behavior.

Example:

    30%
        Warning

    10%
        Critical

    9–5%
        Repeat if dismissed

    4%
        Emergency

    Charging
        Resolve
        Reset

No implementation.

Freeze the specification.

Deliverable: - Functional specification

------------------------------------------------------------------------

## Phase 7 -- Implementation

Only begin implementation after the specification has been frozen.

Rules:

-   Follow the specification exactly.
-   Do not redesign while coding.
-   Do not add unapproved features.
-   If implementation reveals missing information:
    1.  Stop.
    2.  Review documentation.
    3.  Amend the specification.
    4.  Freeze the amendment.
    5.  Continue.

Deliverable: - Source code

------------------------------------------------------------------------

## Phase 8 -- Verification

Verify:

-   Builds successfully.
-   No parser errors.
-   No runtime errors.
-   Existing functionality remains unchanged.
-   No regressions.

Deliverable: - Build verification

------------------------------------------------------------------------

## Phase 9 -- Feature Validation

Validate behavior.

Use:

-   Functional testing
-   Live hardware testing

Example:

    30%
        Warning appears

    10%
        Upgrades to Critical

    9–5%
        Repeats after dismissal

    4%
        Emergency (non-dismissible)

    Charging
        Alert removed

Deliverable: - Validation checklist

------------------------------------------------------------------------

## Phase 10 -- Freeze

Freeze the feature---not the files.

A feature is frozen only after:

-   Design complete
-   Implementation complete
-   Verification complete
-   Hardware validation complete

Future improvements become a new version (e.g. v1.1).

------------------------------------------------------------------------

# Engineering Principles

## Documentation Before Code

Research first. Implement second.

## Reuse Before Creation

Extend existing framework components before creating new ones.

## Single Responsibility

Each component should have one clear responsibility.

-   Providers provide data.
-   Controllers implement policy.
-   Managers coordinate behavior.
-   Components render the UI.

## Freeze Before Building

Implementation begins only after the design has been frozen.

## Amend, Don't Drift

If new information is discovered:

-   Stop
-   Document
-   Review
-   Freeze
-   Continue

Never silently change direction during implementation.

## Validate on Real Hardware

Simulation verifies logic.

Real hardware validates the finished feature.

Both are required before freezing.

------------------------------------------------------------------------

# Vision

The Information Center is developed as an extensible framework.

Future plugins should follow this process, including:

-   Battery Alerts
-   Disk Space Monitoring
-   SMART Drive Health
-   CPU Temperature Alerts
-   Memory Pressure Alerts
-   Network Connectivity Alerts
-   UPS Events
-   Filesystem Warnings

By following this development guide, every feature should integrate
cleanly into the existing architecture while minimizing regressions and
reducing troubleshooting.

------------------------------------------------------------------------

**Status:** Frozen\
**Version:** 1.0
