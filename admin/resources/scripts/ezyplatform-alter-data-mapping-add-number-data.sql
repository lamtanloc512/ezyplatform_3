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
ADD COLUMN `number_data` bigint NOT NULL DEFAULT 0 AFTER `to_data_id`;

ALTER TABLE `ezy_data_mappings`
ADD INDEX `index_mapping_from_pagination` (`mapping_name`, `from_data_id`, `display_order`, `mapped_at`, `to_data_id`),
ADD INDEX `index_mapping_to_pagination` (`mapping_name`, `to_data_id`, `display_order`, `mapped_at`, `from_data_id`);

ALTER TABLE `ezy_data_mappings` DROP INDEX index_mapping_from_at;
ALTER TABLE `ezy_data_mappings` DROP INDEX index_mapping_from_display_order;
ALTER TABLE `ezy_data_mappings` DROP INDEX index_mapping_to_at;
ALTER TABLE `ezy_data_mappings` DROP INDEX index_mapping_to_display_order;
ALTER TABLE `ezy_data_mappings` DROP INDEX index_quantity;
ALTER TABLE `ezy_data_mappings` DROP INDEX index_remaining_quantity;
ALTER TABLE `ezy_data_mappings` DROP INDEX index_decimal_data;
ALTER TABLE `ezy_data_mappings` DROP INDEX index_text_data;
