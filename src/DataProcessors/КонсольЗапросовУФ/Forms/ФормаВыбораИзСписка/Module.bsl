
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ОтборПоКолонкам = "Имя"; //		Выкл.(Выкл.), Имя(Имя), Синоним(Синоним)
	
	ТипОбъекта = Параметры.ТипОбъекта;
	Текст = Параметры.ИмяОбъекта;

	Если ТипОбъекта = "Справочник" Тогда
    	ИмяКоллекции = "Справочники";
    ИначеЕсли ТипОбъекта = "Документ" Тогда
    	ИмяКоллекции = "Документы";
    ИначеЕсли ТипОбъекта = "Перечисление" Тогда
    	ИмяКоллекции = "Перечисления";
    ИначеЕсли ТипОбъекта = "ПланВидовХарактеристик" Тогда
    	ИмяКоллекции = "ПланыВидовХарактеристик";
    ИначеЕсли ТипОбъекта = "ПланСчетов" Тогда
    	ИмяКоллекции = "ПланыСчетов";
    ИначеЕсли ТипОбъекта = "ПланВидовРасчета" Тогда
    	ИмяКоллекции = "ПланыВидовРасчета";
    ИначеЕсли ТипОбъекта = "БизнесПроцесс" Тогда
    	ИмяКоллекции = "БизнесПроцессы";
    ИначеЕсли ТипОбъекта = "Задача" Тогда
    	ИмяКоллекции = "Задачи";
    КонецЕсли; 

	пТЗ = ДанныеФормыВЗначение(ТЗ, Тип("ТаблицаЗначений"));
	
	Если Параметры.Свойство("ПредопределенныеЗначения") Тогда
		
		Если ТипОбъекта = "Документ"
			ИЛИ ТипОбъекта = "БизнесПроцесс"
			ИЛИ ТипОбъекта = "Задача" Тогда
			Отказ = Истина;
			Возврат;
		КонецЕсли; 
		
		ТекстЗапроса = "
		|ВЫБРАТЬ
		| ИмяОбъекта.Ссылка,
		| ПРЕДСТАВЛЕНИЕ(ИмяОбъекта.Ссылка) КАК Представление
		|ИЗ
		| " + ТипОбъекта + "." + Параметры.ИмяОбъекта + " КАК ИмяОбъекта
		|" + ?(НЕ ТипОбъекта = "Перечисление", "
		|ГДЕ
		| ИмяОбъекта.Предопределенный", "");
		
		Запрос = Новый Запрос(ТекстЗапроса);
		Выборка = Запрос.Выполнить().Выбрать();
		ИмяПредопределенного = Неопределено;
		
		Пока Выборка.Следующий() Цикл
			
			НоваяСтрока = пТЗ.Добавить();
			Если ТипОбъекта = "Перечисление" Тогда
				ИндексЗначенияПеречисления = Перечисления[Параметры.ИмяОбъекта].Индекс(Выборка.Ссылка);
				ИмяЗначенияПеречисления = Метаданные.Перечисления[Параметры.ИмяОбъекта].ЗначенияПеречисления[ИндексЗначенияПеречисления].Имя;
				НоваяСтрока.Имя = ИмяЗначенияПеречисления;
				НоваяСтрока.Синоним = Выборка.Представление;
			Иначе
				Выполнить("ИмяПредопределенного = " + ИмяКоллекции + "[""" + Параметры.ИмяОбъекта + """].ПолучитьИмяПредопределенного(Выборка.Ссылка)");
				НоваяСтрока.Имя = ИмяПредопределенного;
				НоваяСтрока.Синоним = Выборка.Представление;
			КонецЕсли;
			
		КонецЦикла;

	Иначе
		
		Для каждого Строка Из Метаданные[ИмяКоллекции] Цикл
			НоваяСтрока = пТЗ.Добавить();
			НоваяСтрока.Имя = Строка.Имя;
			НоваяСтрока.Синоним = Строка.Синоним;
		КонецЦикла;
		
	КонецЕсли;
	
	ЗначениеВДанныеФормы(пТЗ, ТЗ);
    
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
		
	ВыполнитьПоиск();

	Если Не ПустаяСтрока(Параметры.ТекстПоиска) Тогда
		Текст = Параметры.ТекстПоиска;
		ОбновитьОтборТЗ();
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура НайтиТекст(Команда)
	
	ВыполнитьПоиск();
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьПоиск()
	
	Количество = ТЗ.Количество();
	Если Количество = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ИД_ИсходнойСтроки = Элементы.ТЗ.ТекущаяСтрока;
	Если ИД_ИсходнойСтроки = Неопределено Тогда
		ИД_ИсходнойСтроки = 0;
		ИД_СледующейСтроки = 0;
	Иначе
		ИД_СледующейСтроки = ИД_ИсходнойСтроки + 1;
	КонецЕсли;
	
	Если ИД_СледующейСтроки = Количество Тогда
		ИД_СледующейСтроки = 0;
	КонецЕсли;
	
	Для Сч = ИД_СледующейСтроки По Количество Цикл
	
		Если Сч = Количество Тогда
			Сч = 0;
		КонецЕсли;
		
		Если Сч = ИД_ИсходнойСтроки Тогда
			Возврат;
		КонецЕсли;
		
		СтрокаПросмотра = ТЗ[Сч];
		
		Если Найти(ВРег(СтрокаПросмотра.Имя), ВРег(Текст)) ИЛИ Найти(ВРег(СтрокаПросмотра.Синоним), ВРег(Текст)) Тогда
			Элементы.ТЗ.ТекущаяСтрока = СтрокаПросмотра.ПолучитьИдентификатор();
			Возврат;
		КонецЕсли;
	
	КонецЦикла; 
	
КонецПроцедуры

&НаКлиенте
Процедура ОК(Команда)
	
	СделатьВыбор();
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаЗакрыть(Команда)
	
	Закрыть(Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура ТЗВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СделатьВыбор();
	
КонецПроцедуры

&НаКлиенте
Процедура СделатьВыбор()
	
	ИД = Элементы.ТЗ.ТекущаяСтрока;
	Если ИД = Неопределено Тогда
		Закрыть(Неопределено);
		Возврат;
	КонецЕсли; 
	
	ТекущаяСтрока = ТЗ.НайтиПоИдентификатору(ИД);
	Если ТекущаяСтрока = Неопределено Тогда
		Закрыть(Неопределено);
	Иначе
		Закрыть(ТекущаяСтрока.Имя);
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура ТекстПриИзменении(Элемент)
	
	ОбновитьОтборТЗ();
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьОтборПриИзменении(Элемент)
	
	ОбновитьОтборТЗ();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьОтборТЗ()  
	
	Перем ОтборТЗ;
	
	Если		ОтборПоКолонкам = "Имя" Тогда
		ОтборТЗ = Новый ФиксированнаяСтруктура("Имя", Текст);
	ИначеЕсли	ОтборПоКолонкам = "Синоним" Тогда
		ОтборТЗ = Новый ФиксированнаяСтруктура("Синоним", Текст);
	КонецЕсли;
	
	Элементы.ТЗ.ОтборСтрок = ОтборТЗ;
	
КонецПроцедуры // ОбновитьОтборТЗ

