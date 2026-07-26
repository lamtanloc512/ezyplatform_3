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

CREATE TABLE IF NOT EXISTS `ezy_unique_data` (
    `data_type` varchar(120) COLLATE utf8mb4_unicode_520_ci NOT NULL,
    `data_id` bigint unsigned NOT NULL DEFAULT 0,
    `unique_key` varchar(120) COLLATE utf8mb4_unicode_520_ci NOT NULL,
    `text_value` varchar(300) COLLATE utf8mb4_unicode_520_ci,
    `number_value` bigint NOT NULL default 0,
    `decimal_value` DECIMAL(65,2) NOT NULL DEFAULT 0,
    `metadata` mediumtext COLLATE utf8mb4_unicode_520_ci,
    PRIMARY KEY (`data_type`, `data_id`, `unique_key`),
    INDEX `index_data_type_data_id_unique_key_value` (`data_type`, `data_id`, `unique_key`, `text_value`),
    INDEX `index_data_type_data_id_unique_key_number_value` (`data_type`, `data_id`, `unique_key`, `number_value`),
    INDEX `index_data_type_data_id_unique_key_decimal_value` (`data_type`, `data_id`, `unique_key`, `decimal_value`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;
