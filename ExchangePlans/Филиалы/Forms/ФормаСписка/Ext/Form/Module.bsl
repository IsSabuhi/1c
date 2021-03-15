﻿
&НаКлиенте
Процедура ЗарегистрироватьИзменения(Команда)
	ЗарегистрироватьИзмененияНаСервере(Элементы.Список.ТекущаяСтрока);
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ЗарегистрироватьИзмененияНаСервере(Узел)
	// Регистрация изменений всех данных для узла.
	ПланыОбмена.ЗарегистрироватьИзменения(Узел); 
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПредопределенныйУзел(Узел)
	Возврат Узел = ПланыОбмена.Филиалы.ЭтотУзел();
КонецФункции

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	Если ПредопределенныйУзел(Элемент.ТекущаяСтрока) Тогда
		Элементы.ФормаЗарегистрироватьИзменения.Доступность = Ложь;

	Иначе
		Элементы.ФормаЗарегистрироватьИзменения.Доступность = Истина;

	КонецЕсли;

КонецПроцедуры
