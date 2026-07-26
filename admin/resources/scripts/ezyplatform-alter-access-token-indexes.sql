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
DROP INDEX `index_admin_id`;

ALTER TABLE `ezy_admin_access_tokens`
ADD INDEX `index_token_type` (`token_type`);

ALTER TABLE `ezy_admin_access_tokens`
ADD INDEX `index_status` (`status`);

ALTER TABLE `ezy_admin_access_tokens`
ADD INDEX `index_admin_id_pagination` (`admin_id`, `token_type`, `status`, `expired_at`, `id`);

ALTER TABLE `ezy_admin_access_tokens`
ADD INDEX `index_token_type_pagination` (`token_type`, `status`, `expired_at`, `id`);

ALTER TABLE `ezy_admin_access_tokens`
ADD INDEX `index_status_pagination` (`status`, `expired_at`, `id`);

ALTER TABLE `ezy_admin_access_tokens`
ADD INDEX `index_expired_at_pagination` (`expired_at`, `id`);

ALTER TABLE `ezy_user_access_tokens`
DROP INDEX `index_user_id_type_type`;

ALTER TABLE `ezy_user_access_tokens`
ADD UNIQUE KEY `key_token` (`token`);

ALTER TABLE `ezy_user_access_tokens`
ADD INDEX `index_token_type` (`token_type`);

ALTER TABLE `ezy_user_access_tokens`
ADD INDEX `index_status` (`status`);

ALTER TABLE `ezy_user_access_tokens`
ADD INDEX `index_user_id_pagination` (`user_id`, `token_type`, `status`, `expired_at`, `id`);

ALTER TABLE `ezy_user_access_tokens`
ADD INDEX `index_token_type_pagination` (`token_type`, `status`, `expired_at`, `id`);

ALTER TABLE `ezy_user_access_tokens`
ADD INDEX `index_status_pagination` (`status`, `expired_at`, `id`);

ALTER TABLE `ezy_user_access_tokens`
ADD INDEX `index_expired_at_pagination` (`expired_at`, `id`);
