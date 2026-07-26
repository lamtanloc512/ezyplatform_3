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

ALTER TABLE `ezy_data_record_counts`
DROP PRIMARY KEY,
ADD COLUMN `id` bigint unsigned NOT NULL AUTO_INCREMENT FIRST,
MODIFY COLUMN `data_type` varchar(300) COLLATE utf8mb4_unicode_520_ci NOT NULL,
ADD COLUMN `data_name` varchar(150) COLLATE utf8mb4_unicode_520_ci AFTER `data_type`,
ADD COLUMN `record_type` varchar(150) COLLATE utf8mb4_unicode_520_ci AFTER `data_name`,
ADD PRIMARY KEY (`id`),
ADD UNIQUE KEY `key_data_type` (`data_type`),
ADD INDEX `index_data_type_last_counted_at_id` (`data_type`, `last_counted_at`, `id`),
ADD INDEX `index_data_name_record_type` (`data_name`, `record_type`);

ALTER TABLE `ezy_data_record_counts`
DROP INDEX `index_data_type_last_counted_at`;
