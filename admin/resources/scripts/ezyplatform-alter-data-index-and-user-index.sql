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

ALTER TABLE `ezy_user_keywords`
ADD COLUMN `updated_at` datetime AFTER `created_at`,
ADD INDEX `index_keyword_pagination` (`keyword`, `priority`, `id`);

ALTER TABLE `ezy_user_keywords` DROP INDEX `index_keyword`;
ALTER TABLE `ezy_user_keywords` DROP INDEX `index_keyword_pagination`;

ALTER TABLE `ezy_data_indices`
ADD INDEX `index_pagination_data_type_keyword` (`data_type`, `keyword`, `priority`, `id`);

ALTER TABLE `ezy_data_indices`
DROP INDEX `index_key_data_type_id_keyword_priority`;
