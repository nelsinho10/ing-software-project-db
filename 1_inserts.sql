-- Insertando datos iniciales a la base de datos de
USE Marketplace;

INSERT INTO 
    Departments(name_department) 
VALUES 
    ("Atlantida"),
    ("Colon"),
    ("Comayagua"),
    ("Copan"),
    ("Cortes"),
    ("Choluteca"),
    ("El Paraiso"),
    ("Francisco Morazan"),
    ("Gracias a Dios"),
    ("Intibuca"),
    ("Islas de la Bahia"),
    ("La Paz"),
    ("Lempira"),
    ("Ocotepeque"),
    ("Olancho"),
    ("Santa Barbara"),
    ("Valle"),
    ("Yoro")
;

INSERT INTO 
    Municipality(name_municipality,id_department) 
VALUES
    ("La Ceiba",1),
    ("Tela",1),
    ("Jutiapa",1),
    ("La Masica",1),
    ("San Francisco",1),
    ("Arizona",1),
    ("Esparta",1),
    ("El Porvenir",1),
    ("Trujillo",2),
    ("Balfate",2),
    ("Iriona",2),
    ("Limon",2),
    ("Saba",2),
    ("Santa Fe",2),
    ("Santa Rosa de Aguan",2),
    ("Sonaguera",2),
    ("Tocoa",2),
    ("Bonito Oriental",2),
    ("Comayagua",3),
    ("Ajuterique",3),
    ("El Rosario",3),
    ("Esquias",3),
    ("Humuya",3),
    ("La libertad",3),
    ("Lamani",3),
    ("La Trinidad",3),
    ("Lejamani",3),
    ("Meambar",3),
    ("Minas de Oro",3),
    ("Ojos de Agua",3),
    ("San Jeronimo",3),
    ("San Jose de Comayagua",3),
    ("San Jose del Potrero",3),
    ("San Luis",3),
    ("San Sebastian",3),
    ("Siguatepeque",3),
    ("Villa de San Antonio",3),
    ("Las Lajas",3),
    ("Taulabe",3),
    ("Santa Rosa de Copan",4),
    ("Cabañas",4),
    ("Concepcion",4),
    ("Copán Ruinas",4),
    ("Corquin",4),
    ("Cucuyagua",4),
    ("Dolores",4),
    ("Dulce Nombre",4),
    ("El Paraiso",4),
    ("Florida",4),
    ("La Jigua",4),
    ("La Union",4),
    ("Nueva Arcadia",4),
    ("San Agustin",4),
    ("San Antonio",4),
    ("San Jeronimo",4),
    ("San Jose",4),
    ("San Juan de Opoa",4),
    ("San Nicolas",4),
    ("San Pedro",4),
    ("Santa Rita",4),
    ("Trinidad de Copan",4),
    ("Veracruz",4),
    ("San Pedro Sula",5),
    ("Choloma",5),
    ("Omoa",5),
    ("Pimienta",5),
    ("Potrerillos",5),
    ("Puerto Cortes",5),
    ("San Antonio de Cortes",5),
    ("San Francisco de Yojoa",5),
    ("San Manuel",5),
    ("Santa Cruz de Yojoa",5),
    ("Villanueva",5),
    ("La Lima",5),
    ("Choluteca",6),
    ("Apacilagua",6),
    ("Concepcion de Maria",6),
    ("Duyure",6),
    ("El Corpus",6),
    ("El Triunfo",6),
    ("Marcovia",6),
    ("Morolica",6),
    ("Namasigue",6),
    ("Orocuina",6),
    ("Pespire",6),
    ("San Antonio de Flores",6),
    ("San Isidro",6),
    ("San Jose",6),
    ("San Marcos de Colon",6),
    ("Santa Ana de Yusguare",6),
    ("Yuscaran",7),
    ("Alauca",7),
    ("Danli",7),
    ("El Paraiso",7),
    ("Guinope",7),
    ("Jacaleapa",7),
    ("Liure",7),
    ("Moroceli",7),
    ("Oropoli",7),
    ("Potrerillos",7),
    ("San Antonio de Flores",7),
    ("San Lucas",7),
    ("San Matias",7),
    ("Soledad",7),
    ("Teupasenti",7),
    ("Texiguat",7),
    ("Vado Ancho",7),
    ("Yauyupe",7),
    ("Trojes",7),
    ("Distrito Central",8),
    ("Alubaren",8),
    ("Cedros",8),
    ("Curaren",8),
    ("El Porvenir",8),
    ("Guaimaca",8),
    ("La Libertad",8),
    ("La Venta",8),
    ("Lepaterique",8),
    ("Maraita",8),
    ("Marale",8),
    ("Nueva Armenia",8),
    ("Ojojona",8),
    ("Orica",8),
    ("Reitoca",8),
    ("Sabanagrande",8),
    ("San Antonio de Oriente",8),
    ("San Buenaventura",8),
    ("San Ignacio",8),
    ("San Juan de Flores",8),
    ("San Miguelito",8),
    ("Santa Ana",8),
    ("Santa Lucia",8),
    ("Talanga",8),
    ("Tatumbla",8),
    ("Valle de Angeles",8),
    ("Villa de San Francisco",8),
    ("Vallecillo",8),
    ("Puerto Lempira",9),
    ("Brus Laguna",9),
    ("Ahuas",9),
    ("Juan Francisco Bulnes",9),
    ("Ramon Villeda Morales",9),
    ("Wampusirpe",9),
    ("La Esperanza",10),
    ("Camasca",10),
    ("Colomoncagua",10),
    ("Concepcion",10),
    ("Dolores",10),
    ("Intibuca",10),
    ("Jesus de Otoro",10),
    ("Magdalena",10),
    ("Masaguara",10),
    ("San Antonio",10),
    ("San Isidro",10),
    ("San Juan",10),
    ("San Marcos de la Sierra",10),
    ("San Miguel Guancapla",10),
    ("Santa Lucia",10),
    ("Yamaranguila",10),
    ("San Francisco de Opalaca",10),
    ("Roatan",11),
    ("Guanaja",11),
    ("Jose Santos Guardiola",11),
    ("Utila",11),
    ("La Paz",12),
    ("Aguanqueterique",12),
    ("Cabañas",12),
    ("Cane",12),
    ("Chinacla",12),
    ("Guajiquiro",12),
    ("Lauterique",12),
    ("Marcala",12),
    ("Mercedes de Oriente",12),
    ("Opatoro",12),
    ("San Antonio del Norte",12),
    ("San Jose",12),
    ("San Juan",12),
    ("San Pedro de Tutule",12),
    ("Santa Ana",12),
    ("Santa Elena",12),
    ("Santa Maria",12),
    ("Santiago de Puringla",12),
    ("Yarula",12),
    ("Gracias",13),
    ("Belen",13),
    ("Candelaria",13),
    ("Cololaca",13),
    ("Erandique",13),
    ("Gualcince",13),
    ("Guarita",13),
    ("La Campa",13),
    ("La Iguala",13),
    ("Las Flores",13),
    ("La Union",13),
    ("La Virtud",13),
    ("Lepaera",13),
    ("Mapulaca",13),
    ("Piraera",13),
    ("San Andres",13),
    ("San Francisco",13),
    ("San Juan Guarita",13),
    ("San Manuel Colohete",13),
    ("San Rafael",13),
    ("San Sebastian",13),
    ("Santa Cruz",13),
    ("Talgua",13),
    ("Tambla",13),
    ("Tomala",13),
    ("Valladolid",13),
    ("Virginia",13),
    ("San Marcos de Caiquin",13),
    ("Ocotepeque",14),
    ("Belen Gualcho",14),
    ("Concepcion",14),
    ("Dolores Merendon",14),
    ("Fraternidad",14),
    ("La Encarnacion",14),
    ("La Labor",14),
    ("Lucerna",14),
    ("Mercedes",14),
    ("San Fernando",14),
    ("San Francisco del Valle",14),
    ("San Jorge",14),
    ("San Marcos",14),
    ("Santa Fe",14),
    ("Sensenti",14),
    ("Sinuapa",14),
    ("Juticalpa",15),
    ("Campamento",15),
    ("Catacamas",15),
    ("Concordia",15),
    ("Dulce Nombre de Culmi",15),
    ("El Rosario",15),
    ("Esquipulas del Norte",15),
    ("Gualaco",15),
    ("Guarizama",15),
    ("Guata",15),
    ("Guayape",15),
    ("Jano",15),
    ("La Union",15),
    ("Mangulile",15),
    ("Manto",15),
    ("Salama",15),
    ("San Esteban",15),
    ("San Francisco de Becerra",15),
    ("San Francisco de la Paz",15),
    ("Santa Maria del Real",15),
    ("Silca",15),
    ("Yocon",15),
    ("Patuca",15),
    ("Santa Barbara",16),
    ("Arada",16),
    ("Atima",16),
    ("Azacualpa",16),
    ("Ceguaca",16),
    ("Concepcion del Norte",16),
    ("Concepción del Sur",16),
    ("Chinda",16),
    ("El Nispero",16),
    ("Gualala",16),
    ("Ilama",16),
    ("Las Vegas",16),
    ("Macuelizo",16),
    ("Naranjito",16),
    ("Nuevo Celilac",16),
    ("Nueva Frontera",16),
    ("Petoa",16),
    ("Proteccion",16),
    ("Quimistan",16),
    ("San Francisco de Ojuera",16),
    ("San Jose de las Colinas",16),
    ("San Luis",16),
    ("San Marcos",16),
    ("San Nicolas",16),
    ("San Pedro Zacapa",16),
    ("San Vicente Centenario",16),
    ("Santa Rita",16),
    ("Trinidad",16),
    ("Nacaome",17),
    ("Alianza",17),
    ("Amapala",17),
    ("Aramecina",17),
    ("Caridad",17),
    ("Goascoran",17),
    ("Langue",17),
    ("San Francisco de Coray",17),
    ("San Lorenzo",17),
    ("Yoro",18),
    ("Arenal",18),
    ("El Negrito",18),
    ("El Progreso",18),
    ("Jocon",18),
    ("Morazan",18),
    ("Olanchito",18),
    ("Santa Rita",18),
    ("Sulaco",18),
    ("Victoria",18),
    ("Yorito",18)
;

INSERT INTO
    Categories(name_category)
VALUES
    ("Servicios"),
    ("Inmuebles"),
    ("Vehiculos"),
    ("Hogar"),
    ("Moda"),
    ("Futuros padres"),
    ("Mascotas"),
    ("Electronica"),
    ("Negocios"),
    ("Empleo")
;

INSERT INTO
    TypeComplaints(name_complaint)
VALUES
    ("Fraude"),
    ("Venta de Productos Ilegales"),
    ("Publicidad engañosa"),
    ("otros")
;

INSERT INTO
    Configs(time_service,time_announcemen)
VALUES
    (10,10)
;