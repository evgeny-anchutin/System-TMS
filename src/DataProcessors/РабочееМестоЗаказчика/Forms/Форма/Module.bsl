
&НаКлиенте
Перем ФормаОжидания;

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Объект.Заказчик = ПараметрыСеанса.ТекущийПользователь.Заказчик;
	ЗаказчикВыбран = ЗначениеЗаполнено(Объект.Заказчик);
	Элементы.ИнформационнаяНадпись.Видимость = Не ЗаказчикВыбран;
	Элементы.Заказчик.Видимость = ЗаказчикВыбран;
	Элементы.Страницы.Видимость = ЗаказчикВыбран;
	
	Если ЗаказчикВыбран Тогда
		УстановитьОтборы();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборы()
	
	ЭлементОтбора = ЗаявкиНаПеревозку.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Заказчик");
	ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбора.ПравоеЗначение = Объект.Заказчик;
	
	ЭлементОтбора = ПаркТранспортныхСредств.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Владелец");
	ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбора.ПравоеЗначение = Объект.Заказчик;
	
	ЭлементОтбора = ТочкиМаршрута.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Владелец");
	ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбора.ПравоеЗначение = Объект.Заказчик;
	
	ЭлементОтбора = МаршрутныеЗадания.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Заказчик");
	ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбора.ПравоеЗначение = Объект.Заказчик;
	
КонецПроцедуры

&НаКлиенте
Процедура Рассчитать(Команда)
	ФормаОжидания = ОткрытьФорму("Обработка.РабочееМестоЗаказчика.Форма.ФормаВыполнения",, ЭтаФорма,,,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	ПодключитьОбработчикОжидания("ПроверитьВыполнениеЗадания", 1, Истина);
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьВыполнениеЗадания() Экспорт
	
	// Заглушка для демонстрации работы. Настоящее API будет в рабочем варианте
	
	Прогресс = Прогресс + 4;
	
	Если Прогресс >= 100 Тогда
		Если ФормаОжидания <> Неопределено Тогда
			ФормаОжидания.Закрыть();
			ФормаОжидания = Неопределено;
		КонецЕсли;
		ПоказатьПредупреждение(, "Формирование маршрутных заданий выполнено");
	Иначе
		ФормаОжидания.Прогресс = Прогресс;
		ПодключитьОбработчикОжидания("ПроверитьВыполнениеЗадания", 1, Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "ПрерваноВыполнениеРасчетаМаршрута" Тогда
		ОтключитьОбработчикОжидания("ПроверитьВыполнениеЗадания");
		ПоказатьПредупреждение(, "Формирование маршрутных заданий прервано");
	КонецЕсли;
КонецПроцедуры
