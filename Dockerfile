# syntax=docker/dockerfile:1

# We fetch and build a specific unreleased version of HLint as well,
# since a version of HLint with SARIF support has not been released yet.
#
# Once one has been, we may either continue to bundle the hlint binary
# together but at a more stable and official set of versions.
# Alternatively, we could have the action retrieve an hlint release
# automatically if one is not already available locally in the action.

FROM haskell:9.4.5@sha256:f33e8cb119fd5b436c39a3f45000bf732bce8e2ac71553ac5d307c10d01418ba AS build
RUN mkdir -p /src
WORKDIR /src
RUN git clone https://github.com/haskell-actions/hlint-scan.git
WORKDIR /src/hlint-scan
RUN stack install hlint hlint-scan:exe:hlint-scan
RUN cp $(stack path --local-bin)/hlint /
RUN cp $(stack path --local-bin)/hlint-scan /

FROM haskell:9.4.5-slim@sha256:3af1d7811b29ea428819d3a34c66c8af9befdc669d3c1c7bc43c0ec459deb4cd
COPY --from=build /hlint /hlint-scan /
ENTRYPOINT ["/hlint-scan"]
