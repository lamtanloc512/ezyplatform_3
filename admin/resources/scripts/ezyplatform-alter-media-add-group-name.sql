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
ADD COLUMN `group_name` varchar(80) COLLATE utf8mb4_unicode_520_ci AFTER `original_name`;

ALTER TABLE `ezy_medias`
ADD INDEX `index_group_name` (`group_name`);

ALTER TABLE `ezy_medias`
ADD INDEX `index_pagination_group_name` (`group_name`, `owner_admin_id`, `owner_user_id`, `upload_from`, `media_type`, `public_media`, `status`, `file_size`, `id`);
