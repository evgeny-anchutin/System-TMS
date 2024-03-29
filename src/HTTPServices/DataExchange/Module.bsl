Процедура ЗаписатьМассивJSON(МассивЭлементов, ЗаписьJSON)

	ЗаписьJSON.ЗаписатьНачалоМассива();
	
	Для каждого Элемент Из МассивЭлементов Цикл
		ЗаписьJSON.ЗаписатьЗначение("" + Элемент);
	КонецЦикла;
	
	ЗаписьJSON.ЗаписатьКонецМассива();

КонецПроцедуры


Функция get_data(Запрос)
	
	Сервисы.ЗаписьЛога("get");
	ИмяМетода = Запрос.ПараметрыURL["ИмяМетода"];
	Параметр = Запрос.ПараметрыЗапроса.Получить("document_id");
	
	Если ИмяМетода = "GetData" Тогда
	
		Если Параметр = Неопределено Тогда
	
			Запрос = Новый Запрос;
			Запрос.Текст = 
				"ВЫБРАТЬ
				|	МаршрутноеЗаданиеЗаявкиНаПеревозку.Заявка КАК Заявка,
				|	МаршрутноеЗаданиеЗаявкиНаПеревозку.ПунктПогрузки.Наименование КАК startAddress,
				|	МаршрутноеЗаданиеЗаявкиНаПеревозку.ПунктРазгрузки.Наименование КАК finishAddress,
				|	МаршрутноеЗаданиеЗаявкиНаПеревозку.ВидГруза.Наименование КАК name,
				|	МаршрутноеЗаданиеЗаявкиНаПеревозку.Объем КАК volume,
				|	МаршрутноеЗаданиеЗаявкиНаПеревозку.Вес КАК weight
				|ИЗ
				|	Документ.МаршрутноеЗадание.ЗаявкиНаПеревозку КАК МаршрутноеЗаданиеЗаявкиНаПеревозку
				|ГДЕ
				|	МаршрутноеЗаданиеЗаявкиНаПеревозку.Ссылка.Перевозчик = &Перевозчик";
			
			Запрос.УстановитьПараметр("Перевозчик", ПараметрыСеанса.ТекущийПользователь.Перевозчик);
			РезультатЗапроса = Запрос.Выполнить();
			ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
			
			МассивСтруктур = Новый Массив;
			Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
				Структура = Новый Структура("startAddress,finishAddress,name,volume,weight");
				ЗаполнитьЗначенияСвойств(Структура, ВыборкаДетальныеЗаписи);
				Структура.Вставить("document_id", Строка(ВыборкаДетальныеЗаписи.Заявка.УникальныйИдентификатор()));
				МассивСтруктур.Добавить(Структура);
			КонецЦикла;
			
			ЗаписьJSON = Новый ЗаписьJSON;
			ЗаписьJSON.УстановитьСтроку();
			
			ЗаписатьJSON(ЗаписьJSON, МассивСтруктур);
			
			//ЗаписьJSON.ПроверятьСтруктуру = Ложь;
			//ПараметрыЗаписиJSON = Новый ПараметрыЗаписиJSON(,Символы.Таб);
			//ЗаписьJSON.УстановитьСтроку(ПараметрыЗаписиJSON);
			//
			//МассивЭлементов = РезультатЗапроса.Выгрузить().ВыгрузитьКолонку("Заявка");
			//МассивКодов = Новый Массив;
			//Для каждого Заявка Из МассивЭлементов Цикл
			//	МассивКодов.Добавить("" + Заявка.УникальныйИдентификатор());
			//КонецЦикла;
			//ЗаписатьМассивJSON(МассивКодов, ЗаписьJSON);
			//
			//МассивЭлементов = РезультатЗапроса.Выгрузить().ВыгрузитьКолонку("ПунктПогрузки");
			//ЗаписатьМассивJSON(МассивЭлементов, ЗаписьJSON);
			//
			//МассивЭлементов = РезультатЗапроса.Выгрузить().ВыгрузитьКолонку("ПунктРазгрузки");
			//ЗаписатьМассивJSON(МассивЭлементов, ЗаписьJSON);
			//
			//МассивЭлементов = РезультатЗапроса.Выгрузить().ВыгрузитьКолонку("ВидГруза");
			//ЗаписатьМассивJSON(МассивЭлементов, ЗаписьJSON);
			//
			//МассивЭлементов = РезультатЗапроса.Выгрузить().ВыгрузитьКолонку("Объем");
			//ЗаписатьМассивJSON(МассивЭлементов, ЗаписьJSON);
			//
			//МассивЭлементов = РезультатЗапроса.Выгрузить().ВыгрузитьКолонку("Вес");
			//ЗаписатьМассивJSON(МассивЭлементов, ЗаписьJSON);
			
			Ответ = Новый HTTPСервисОтвет(200);
			Ответ.УстановитьТелоИзСтроки("" + ЗаписьJSON.Закрыть(), КодировкаТекста.UTF8);
			
			Ответ.Заголовки.Вставить("Content-type", "application/json");
			
		Иначе
			
			УстановитьПривилегированныйРежим(Истина);
			ЗаявкаНаПеревозку = Документы.ЗаявкаНаПеревозку.ПолучитьСсылку(Новый УникальныйИдентификатор(Параметр));
			ЗаявкаНаПеревозкуОбъект = ЗаявкаНаПеревозку.ПолучитьОбъект();
			ЗаявкаНаПеревозкуОбъект.Статус = Перечисления.СтатусыЗаявокНаПеревозку.Доставлено;
			ЗаявкаНаПеревозкуОбъект.Записать(РежимЗаписиДокумента.Запись);
			УстановитьПривилегированныйРежим(Ложь);
			
			СтруктураОтвета = Новый Структура("result", "Установлен статус ""Доставлено""");
			ЗаписьJSON = Новый ЗаписьJSON;
			ЗаписьJSON.УстановитьСтроку();
			ЗаписатьJSON(ЗаписьJSON, СтруктураОтвета);
			Ответ = Новый HTTPСервисОтвет(200);
			Ответ.УстановитьТелоИзСтроки(ЗаписьJSON.Закрыть(), КодировкаТекста.UTF8);
		
		КонецЕсли;
	
	Иначе
	
		Ответ = Новый HTTPСервисОтвет(404);
		Ответ.УстановитьТелоИзСтроки("Неизвестное имя метода");

	КонецЕсли;
	
	Возврат Ответ;
	
КонецФункции

Функция post_data(Запрос)
	
	//Сервисы.ЗаписьЛога("post");
	ИмяМетода = Запрос.ПараметрыURL["ИмяМетода"];
    //Сервисы.ЗаписьЛога(ИмяМетода);
	
	Если ИмяМетода = "SetData" Тогда
		
		//ТипСодержимого = Запрос.Заголовки.Получить("Content-Type");
		//
		//Сервисы.ЗаписьЛога(ТипСодержимого);
		//
		//Если ТипСодержимого <> "text/html" И  ТипСодержимого <> "text/plain" Тогда
		//	// Сообщаем клиенту, что не поддерживаем такой тип содержимого
		//	Ответ = Новый HTTPСервисОтвет(415);        
		//Иначе
			Описание = Запрос.ПолучитьТелоКакСтроку();
			Сервисы.ЗаписьЛога(Описание);
			Ответ = Новый HTTPСервисОтвет(204);        
		//КонецЕсли;

	ИначеЕсли ИмяМетода = "GetData" Тогда
		
		Ответ = Новый HTTPСервисОтвет(200);
		Ответ.УстановитьТелоИзСтроки("test description");
		Ответ.Заголовки["Content-Type"] = "text/html";
		
	Иначе
		
		Ответ = Новый HTTPСервисОтвет(404);
		Ответ.УстановитьТелоИзСтроки("Неизвестное имя метода");

	КонецЕсли;
	
	//Артикул = Запрос.ПараметрыЗапроса.Получить("Article");

	//Если Артикул = Неопределено Тогда

	//	Ответ = Новый HTTPСервисОтвет(400);
	//	Ответ.УстановитьТелоИзСтроки("Не задан параметр Article");
	//	Возврат Ответ;

	//  КонецЕсли;
		
	Ответ = Новый HTTPСервисОтвет(200);
	Возврат Ответ;
	
КонецФункции
