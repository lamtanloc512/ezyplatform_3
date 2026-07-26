/*
 * Copyright 2024 youngmonkeys.org
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

ALTER TABLE `ezy_links`
ADD COLUMN `source_type` varchar(50) COLLATE utf8mb4_unicode_520_ci NOT NULL DEFAULT 'UNKNOWN' AFTER `description`,
ADD COLUMN `source_id` bigint unsigned NOT NULL DEFAULT 0 AFTER `source_type`,
ADD INDEX `source_type_id` (`source_type`, `source_id`),
ADD INDEX `source_type` (`source_type`);
