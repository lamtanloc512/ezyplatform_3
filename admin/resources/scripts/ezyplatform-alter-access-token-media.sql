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

ALTER TABLE `ezy_admin_access_tokens`
ADD COLUMN `token_type` varchar(50) NOT NULL DEFAULT 'ACCESS_TOKEN'
AFTER `renewal_count`;

ALTER TABLE `ezy_admin_access_tokens`
DROP INDEX `index_admin_id`;

ALTER TABLE `ezy_admin_access_tokens`
ADD INDEX `index_admin_id_type_type` (`admin_id`, `token_type`);

ALTER TABLE `ezy_user_access_tokens`
ADD COLUMN `token_type` varchar(50) NOT NULL DEFAULT 'ACCESS_TOKEN'
AFTER `renewal_count`;

ALTER TABLE `ezy_user_access_tokens`
DROP INDEX `index_user_id`;

ALTER TABLE `ezy_user_access_tokens`
ADD INDEX `index_user_id_type_type` (`user_id`, `token_type`);

ALTER TABLE `ezy_medias`
ADD COLUMN `file_size` bigint NOT NULL DEFAULT 0
AFTER `description`;

ALTER TABLE `ezy_medias`
ADD COLUMN `status` varchar(50) COLLATE utf8mb4_unicode_520_ci NOT NULL DEFAULT 'ADDED'
AFTER `public_media`;

ALTER TABLE `ezy_medias`
ADD INDEX `index_public_media` (`public_media`),
ADD INDEX `index_status` (`status`),
ADD INDEX `index_pagination_owner_user_id` (`owner_user_id`, `upload_from`, `media_type`, `public_media`, `status`, `file_size`, `id`),
ADD INDEX `index_pagination_owner_admin_id` (`owner_admin_id`, `upload_from`, `media_type`, `public_media`, `status`, `file_size`, `id`),
ADD INDEX `index_pagination_upload_from` (`upload_from`, `media_type`, `public_media`, `status`, `file_size`, `id`),
ADD INDEX `index_pagination_media_type` (`media_type`, `public_media`, `status`, `file_size`, `id`),
ADD INDEX `index_pagination_status` (`status`, `file_size`, `id`);

ALTER TABLE `ezy_medias` DROP INDEX `index_owner_user_id`;
ALTER TABLE `ezy_medias` DROP INDEX `index_owner_admin_id`;
ALTER TABLE `ezy_medias` DROP INDEX `index_owner_public_media`;
