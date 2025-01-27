﻿
Процедура Печать(ТабДок, Ссылка) Экспорт
	//{{_КОНСТРУКТОР_ПЕЧАТИ(Печать)
	Макет = Документы.УслугаСтрижки.ПолучитьМакет("Печать");
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	УслугаСтрижки.Администратор,
	|	УслугаСтрижки.ВремяЗаписи,
	|	УслугаСтрижки.Дата,
	|	УслугаСтрижки.Клиент,
	|	УслугаСтрижки.Мастер,
	|	УслугаСтрижки.Номер,
	|	УслугаСтрижки.Склад,
	|	УслугаСтрижки.ПереченьУслуг.(
	|		НомерСтроки,
	|		Номенклатура1,
	|		Цена1
	|	),
	|	УслугаСтрижки.ПереченьНоменклатуры.(
	|		НомерСтроки,
	|		Номенклатура,
	|		НаборСвойств,
	|		Количество,
	|		Цена,
	|		Сумма
	|	)
	|ИЗ
	|	Документ.УслугаСтрижки КАК УслугаСтрижки
	|ГДЕ
	|	УслугаСтрижки.Ссылка В (&Ссылка)";
	Запрос.Параметры.Вставить("Ссылка", Ссылка);
	Выборка = Запрос.Выполнить().Выбрать();

	ОбластьЗаголовок = Макет.ПолучитьОбласть("Заголовок");
	Шапка = Макет.ПолучитьОбласть("Шапка");
	ОбластьПереченьУслугШапка = Макет.ПолучитьОбласть("ПереченьУслугШапка");
	ОбластьПереченьУслуг = Макет.ПолучитьОбласть("ПереченьУслуг");
	ОбластьПереченьНоменклатурыШапка = Макет.ПолучитьОбласть("ПереченьНоменклатурыШапка");
	ОбластьПереченьНоменклатуры = Макет.ПолучитьОбласть("ПереченьНоменклатуры");
	ТабДок.Очистить();

	ВставлятьРазделительСтраниц = Ложь;
	Пока Выборка.Следующий() Цикл
		Если ВставлятьРазделительСтраниц Тогда
			ТабДок.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;

		ТабДок.Вывести(ОбластьЗаголовок);

		Шапка.Параметры.Заполнить(Выборка);
		ТабДок.Вывести(Шапка, Выборка.Уровень());

		ТабДок.Вывести(ОбластьПереченьУслугШапка);
		ВыборкаПереченьУслуг = Выборка.ПереченьУслуг.Выбрать();
		Пока ВыборкаПереченьУслуг.Следующий() Цикл
			ОбластьПереченьУслуг.Параметры.Заполнить(ВыборкаПереченьУслуг);
			ТабДок.Вывести(ОбластьПереченьУслуг, ВыборкаПереченьУслуг.Уровень());
		КонецЦикла;

		ТабДок.Вывести(ОбластьПереченьНоменклатурыШапка);
		ВыборкаПереченьНоменклатуры = Выборка.ПереченьНоменклатуры.Выбрать();
		Пока ВыборкаПереченьНоменклатуры.Следующий() Цикл
			ОбластьПереченьНоменклатуры.Параметры.Заполнить(ВыборкаПереченьНоменклатуры);
			ТабДок.Вывести(ОбластьПереченьНоменклатуры, ВыборкаПереченьНоменклатуры.Уровень());
		КонецЦикла;

		ВставлятьРазделительСтраниц = Истина;
	КонецЦикла;
	//}}
КонецПроцедуры
