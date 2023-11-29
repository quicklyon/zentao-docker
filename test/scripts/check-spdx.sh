#!/bin/bash
# Copyright ZenTao, Inc.
# SPDX-License-Identifier: APACHE-2.0

set -o errexit
set -o nounset
set -o pipefail

mapfile -t files < <( find /opt/zbox "$ZBOX_ROOT_DIR" -type f -name '*.spdx' )

[[ ${#files[@]} -gt 0 ]]
