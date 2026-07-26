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

ALTER TABLE `ezy_content_templates`
ADD COLUMN `owner_type` varchar(120) COLLATE utf8mb4_unicode_520_ci NOT NULL DEFAULT 'ALL' AFTER `id`,
ADD COLUMN `owner_id` bigint unsigned NOT NULL DEFAULT 0 AFTER `owner_type`,
ADD COLUMN `creator_type` varchar(50) COLLATE utf8mb4_unicode_520_ci NOT NULL DEFAULT 'ADMIN' AFTER `content_type`,
ADD UNIQUE KEY `key_owner_template_name_type` (`owner_type`, `owner_id`, `template_type`, `template_name`),
ADD INDEX `index_template_type_name_status_id` (`template_type`, `template_name`, `status`, `id`),
ADD INDEX `index_pagination_all` (`owner_type`, `owner_id`, `template_type`, `template_name`, `status`, `id`);

ALTER TABLE `ezy_content_templates` DROP INDEX `key_template_type_name`;
ALTER TABLE `ezy_content_templates` DROP INDEX `index_template_type`;
ALTER TABLE `ezy_content_templates` DROP INDEX `index_template_name`;
ALTER TABLE `ezy_content_templates` DROP INDEX `index_creator_id`;
ALTER TABLE `ezy_content_templates` DROP INDEX `index_status`;
ALTER TABLE `ezy_content_templates` DROP INDEX `index_created_at`;
ALTER TABLE `ezy_content_templates` DROP INDEX `index_updated_at`;
