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

ALTER TABLE `ezy_medias`
DROP INDEX index_pagination_media_type;

ALTER TABLE `ezy_medias`
DROP INDEX index_pagination_status;

ALTER TABLE `ezy_medias`
ADD INDEX `index_pagination_media_type` (`media_type`, `public_media`, `status`, `created_at`, `updated_at`, `file_size`, `id`);

ALTER TABLE `ezy_medias`
ADD INDEX `index_pagination_status` (`status`, `created_at`, `updated_at`, `file_size`, `id`);

ALTER TABLE `ezy_medias`
ADD INDEX `index_pagination_created_at` (`created_at`, `id`);

ALTER TABLE `ezy_medias`
ADD INDEX `index_pagination_updated_at` (`updated_at`, `id`);
