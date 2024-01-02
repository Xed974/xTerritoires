
CREATE TABLE `territoires` (
  `id` int(11) NOT NULL,
  `zone` varchar(30) DEFAULT NULL,
  `label` varchar(30) NOT NULL,
  `owner` varchar(40) DEFAULT NULL,
  `data` longtext NOT NULL DEFAULT '[]'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

ALTER TABLE `territoires`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `territoires`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;
COMMIT;