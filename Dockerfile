# syntax=docker/dockerfile:1

# We fetch and build a specific unreleased version of HLint as well,
# since a version of HLint with SARIF support has not been released yet.
#
# Once one has been, we may either continue to bundle the hlint binary
# together but at a more stable and official set of versions.
# Alternatively, we could have the action retrieve an hlint release
# automatically if one is not already available locally in the action.

FROM haskell:9.4.4@sha256:956023a248c1a61016e56d4b5d066ac2450f7c1289f6726dbb1a4b16f8e35d26 AS build
RUN mkdir -p /src
WORKDIR /src
RUN git clone https://github.com/haskell-actions/hlint-scan.git
WORKDIR /src/hlint-scan
RUN stack install hlint hlint-scan:exe:hlint-scan
RUN cp $(stack path --local-bin)/hlint /
RUN cp $(stack path --local-bin)/hlint-scan /

FROM haskell:9.4.4-slim@sha256:854ca6084774f8a75b2d80be47848b363683b2a883c268ab6ff88b57129ca219
COPY --from=build /hlint /hlint-scan /
ENTRYPOINT ["/hlint-scan"]
