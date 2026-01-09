CREATE TABLE `electric_vehicle_project.ev_charging_ports2` (
  `year` smallint unsigned DEFAULT NULL,
  `state` varchar(100) DEFAULT NULL,
  `ev_charging_port_count` smallint unsigned DEFAULT NULL,
  `level_1_port_count` smallint unsigned DEFAULT NULL,
  `level_2_port_count` smallint unsigned DEFAULT NULL,
  `dc_fast_port_count` smallint unsigned DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;