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

ALTER TABLE `ezy_data_mappings`
ADD COLUMN `display_order` bigint NOT NULL DEFAULT 0 AFTER `to_data_id`,
ADD COLUMN `quantity` bigint unsigned NOT NULL DEFAULT 0 AFTER `display_order`,
ADD COLUMN `remaining_quantity` bigint unsigned NOT NULL DEFAULT 0 AFTER `quantity`,
ADD COLUMN `decimal_data` DECIMAL(65,2) NOT NULL DEFAULT 0 AFTER `remaining_quantity`,
ADD COLUMN `text_data` varchar(300) COLLATE utf8mb4_unicode_520_ci AFTER `decimal_data`,
ADD INDEX `index_mapping_from_display_order` (`mapping_name`, `from_data_id`, `display_order`),
ADD INDEX `index_mapping_to_display_order` (`mapping_name`, `to_data_id`, `display_order`),
ADD INDEX `index_quantity` (`quantity`),
ADD INDEX `index_remaining_quantity` (`remaining_quantity`),
ADD INDEX `index_decimal_data` (`decimal_data`),
ADD INDEX `index_text_data` (`text_data`);
