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

UPDATE `ezy_links`
SET `link_uri` = LEFT(`link_uri`, 300)
WHERE CHAR_LENGTH(`link_uri`) > 300;

ALTER TABLE `ezy_links`
MODIFY COLUMN `link_uri` varchar(300) NOT NULL;

ALTER TABLE `ezy_links`
MODIFY COLUMN `description` mediumtext COLLATE utf8mb4_unicode_520_ci,
ADD COLUMN `status` varchar(50) COLLATE utf8mb4_unicode_520_ci AFTER `description`,
ADD INDEX `updated_at_id` (`updated_at`, `id`),
ADD INDEX `link_type_pagination` (`link_type`, `source_type`, `source_id`, `status`, `updated_at`, `id`),
ADD INDEX `source_pagination` (`source_type`, `source_id`, `status`, `updated_at`, `id`);

ALTER TABLE `ezy_links` DROP INDEX `updated_at`;
