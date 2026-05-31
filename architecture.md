# Architecture Guidelines

## When proposing architecture

1. TODO: Start with the simplest viable structure.
2. TODO: Explain what problem each layer solves.
3. TODO: Call out what can be deferred.
4. TODO: Avoid adding backend, database, auth, queues, or services unless needed.
5. TODO: Prefer local-first or client-side solutions for small personal tools unless there is a clear reason not to.

## Layering

- TODO: Keep boundaries obvious (UI / domain / data / integrations).
- TODO: Prefer dependency direction toward stable abstractions.

## Defaults to defer

- TODO: Auth, multi-tenancy, microservices, event buses, and heavy infra until a concrete need appears.
