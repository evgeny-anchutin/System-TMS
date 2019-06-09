
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Если ТипЗнч(Параметры.ПараметрыВыбора) = Тип("Структура")
			И Параметры.ПараметрыВыбора.Свойство("Заказчик")
			И ЗначениеЗаполнено(Параметры.ПараметрыВыбора.Заказчик) Тогда
			Объект.Владелец = Параметры.ПараметрыВыбора.Заказчик
		ИначеЕсли ЗначениеЗаполнено(ПараметрыСеанса.ТекущийПользователь.Заказчик) Тогда
			Объект.Владелец = ПараметрыСеанса.ТекущийПользователь.Заказчик;
		КонецЕсли;
	КонецЕсли;
	Элементы.Владелец.ТолькоПросмотр = Не РольДоступна("ПолныеПрава");
КонецПроцедуры
