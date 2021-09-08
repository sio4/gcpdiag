#!/bin/bash
# Copyright 2021 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -e
set -u
set -o pipefail

REPORT_FILE=test_report.txt

PATH="${KOKORO_ARTIFACTS_DIR}/github/gcp-doctor/bin:$HOME/.local/bin:$PATH"
cd "${KOKORO_ARTIFACTS_DIR}/github/gcp-doctor"

{
  echo -n "Date: "
  date
  echo "Git commit: $KOKORO_GIT_COMMIT"
  echo "Github pull request: $KOKORO_GITHUB_PULL_REQUEST_NUMBER"
  echo

  set -x
  pipenv-dockerized run pipenv install --dev
  pipenv-dockerized run pre-commit run --all-files
  pipenv-dockerized run make test
} 2>&1 | tee $REPORT_FILE