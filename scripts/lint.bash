#!/usr/bin/env bash

shellcheck --shell=bash --external-sources \
	bin/* --source-path=SCRIPTDIR \
	lib/* \
	scripts/*

shfmt --language-dialect bash --diff \
	bin/* \
	lib/* \
	scripts/*
