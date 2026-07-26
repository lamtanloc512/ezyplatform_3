/*
 * Copyright 2025 youngmonkeys.org
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

ALTER TABLE `ezy_admin_meta`
MODIFY COLUMN `meta_key` varchar(255) COLLATE utf8mb4_unicode_520_ci NOT NULL;

ALTER TABLE `ezy_user_meta`
MODIFY COLUMN `meta_key` varchar(255) COLLATE utf8mb4_unicode_520_ci NOT NULL;

ALTER TABLE `ezy_data_meta`
MODIFY COLUMN `data_type` varchar(120) COLLATE utf8mb4_unicode_520_ci NOT NULL,
MODIFY COLUMN `meta_key` varchar(255) COLLATE utf8mb4_unicode_520_ci NOT NULL;
