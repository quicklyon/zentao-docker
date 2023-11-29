#!/bin/bash
# Copyright ZenTao, Inc.
# SPDX-License-Identifier: APACHE-2.0

set -o errexit
set -o nounset
set -o pipefail

mapfile -t files < <( find "$ZBOX_ROOT_DIR" -type f -executable )

for file in "${files[@]}"; do
  if [[ -n $EXCLUDE_PATHS ]] && [[ "$file" =~ $EXCLUDE_PATHS ]]; then
    continue
  fi
  [[ $(ldd "$file" | grep -c "not found") -eq 0 ]] || exit 1
done
