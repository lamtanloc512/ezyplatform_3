/*
 * Copyright 2022 youngmonkeys.org
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

CREATE TABLE IF NOT EXISTS `ezy_data_mappings` (
    `mapping_name` varchar(120) COLLATE utf8mb4_unicode_520_ci NOT NULL,
    `from_data_id` bigint unsigned NOT NULL,
    `to_data_id` bigint unsigned NOT NULL,
    `display_order` bigint NOT NULL DEFAULT 0,
    `quantity` bigint unsigned NOT NULL DEFAULT 0,
    `remaining_quantity` bigint unsigned NOT NULL DEFAULT 0,
    `number_data` bigint NOT NULL DEFAULT 0,
    `decimal_data` DECIMAL(65,2) NOT NULL DEFAULT 0,
    `text_data` varchar(300) COLLATE utf8mb4_unicode_520_ci,
    `metadata` mediumtext COLLATE utf8mb4_unicode_520_ci,
    `mapped_at` datetime NOT NULL,
    PRIMARY KEY (`mapping_name`, `from_data_id`, `to_data_id`),
    INDEX `index_mapping_name_pagination` (`mapping_name`, `from_data_id`, `to_data_id`, `quantity`, `remaining_quantity`, `number_data`, `decimal_data`, `text_data`, `display_order`, `mapped_at`),
    INDEX `index_from_data_id_pagination` (`from_data_id`, `mapping_name`, `to_data_id`, `quantity`, `remaining_quantity`, `number_data`, `decimal_data`, `text_data`, `display_order`, `mapped_at`),
    INDEX `index_to_data_id_pagination` (`to_data_id`, `mapping_name`, `from_data_id`, `quantity`, `remaining_quantity`, `number_data`, `decimal_data`, `text_data`, `display_order`, `mapped_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;
