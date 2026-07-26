/*!
 * Copyright 2022 youngmonkeys.org
 *
 * Licensed under the ezyplatform, Version 1.0.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     https://youngmonkeys.org/licenses/ezyplatform-1.0.0.txt
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
*/

ezyadmin.togglePasswordVisible = function(inputId, showButtonId, hideButtonId) {
    var pwdInput = $(`#${inputId}`);
    var showButton = $(`#${showButtonId}`);
    var hideButton = $(`#${hideButtonId}`);
    var pwdInputType = pwdInput.attr('type');
    if (pwdInputType == 'password') {
        pwdInput.attr('type', 'text');
        showButton.addClass('d-none');
        hideButton.removeClass('d-none');
    } else {
        pwdInput.attr('type', 'password');
        showButton.removeClass('d-none');
        hideButton.addClass('d-none');
    }
}
