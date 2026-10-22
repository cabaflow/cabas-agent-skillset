## Skill routing (Caba's Agent Skillset)
These skills may be listed by name only; this table says when to load them. Load only skills whose trigger matches, usually 1, at most 3. Trivial edits and plain questions: load none.
- New page, landing, or polishing/fixing an existing UI → impeccable
- User likes a site or app and wants something similar → ui-capture + extract-design-system, then impeccable to adapt
- Exact clone of a URL → ui-capture + ui-reverse-engineering
- New or smoother animation → animate. Janky animation → animation-performance
- iOS-style gestures, sheets, springs → apple-design (not because a site is Apple's)
- Iterating a UI with feedback (keep X, change Y) → ui-convergence
- Checking finished work is ready, showing results or a demo → honest-delivery (+ playwright-cli to test it); no design skills unless asked to change the design
- React component structure → vercel-composition-patterns. React performance → vercel-react-best-practices
- Supabase → supabase; add supabase-postgres-best-practices for schema, RLS or SQL
- Test a flow in a browser → playwright-cli
- Review a diff for security, auth or permissions → differential-review. Plain PR review → the built-in code-review
- Slash-only, so tell the user to run them: UI variants to choose from → /prototype; choosing a component library → /pick-ui-library; reviewing existing animation code → /review-animations
