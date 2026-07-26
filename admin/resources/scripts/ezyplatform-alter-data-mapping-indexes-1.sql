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

ALTER TABLE `ezy_data_mappings`
DROP INDEX `index_from_to_data`;

ALTER TABLE `ezy_data_mappings`
DROP INDEX `index_to_from_data`;

ALTER TABLE `ezy_data_mappings`
DROP INDEX `index_mapping_from_pagination`;

ALTER TABLE `ezy_data_mappings`
DROP INDEX `index_mapping_to_pagination`;

ALTER TABLE `ezy_data_mappings`
ADD INDEX `index_mapping_name_pagination` (`mapping_name`, `from_data_id`, `to_data_id`, `quantity`, `remaining_quantity`, `number_data`, `decimal_data`, `text_data`, `display_order`, `mapped_at`);

ALTER TABLE `ezy_data_mappings`
ADD INDEX `index_from_data_id_pagination` (`from_data_id`, `mapping_name`, `to_data_id`, `quantity`, `remaining_quantity`, `number_data`, `decimal_data`, `text_data`, `display_order`, `mapped_at`);

ALTER TABLE `ezy_data_mappings`
ADD INDEX `index_to_data_id_pagination` (`to_data_id`, `mapping_name`, `from_data_id`, `quantity`, `remaining_quantity`, `number_data`, `decimal_data`, `text_data`, `display_order`, `mapped_at`);
