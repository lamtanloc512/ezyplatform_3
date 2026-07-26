/*
 * Copyright 2026 youngmonkeys.org
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

ALTER TABLE `ezy_admin_access_tokens`
CHANGE COLUMN `id` `token` varchar(300) NOT NULL FIRST;

ALTER TABLE `ezy_admin_access_tokens`
DROP PRIMARY KEY,
ADD COLUMN `id` bigint unsigned NOT NULL AUTO_INCREMENT FIRST,
ADD PRIMARY KEY (`id`),
ADD UNIQUE KEY `key_token` (`token`);

ALTER TABLE `ezy_user_access_tokens`
CHANGE COLUMN `id` `token` varchar(300) NOT NULL FIRST;

ALTER TABLE `ezy_user_access_tokens`
DROP PRIMARY KEY,
ADD COLUMN `id` bigint unsigned NOT NULL AUTO_INCREMENT FIRST,
ADD PRIMARY KEY (`id`);
