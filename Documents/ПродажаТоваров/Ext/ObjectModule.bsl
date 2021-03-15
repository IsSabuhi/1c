﻿

Процедура ОбработкаПроведения(Отказ, Режим)
	
	
Движения.ОстаткиМатериалов.Записывать = Истина;
Движения.СтоимостьМатериалов.Записывать = Истина;
Движения.Продажи.Записывать = Истина;
Движения.Управленческий.Записывать = Истина;

 //Создать менеджер временных таблиц
	МенеджерВТ = Новый МенеджерВременныхТаблиц;

#Область НоменклатураДокумента	
Запрос = Новый Запрос;

 //Укажем, какой менеджер временных таблиц использует этот запрос
Запрос.МенеджерВременныхТаблиц = МенеджерВТ;
	
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ПродажаТоваровПереченьНоменклатуры.Номенклатура КАК Номенклатура,
		|	ПродажаТоваровПереченьНоменклатуры.НаборСвойств КАК НаборСвойств,
		|	ПродажаТоваровПереченьНоменклатуры.Номенклатура.ВидНоменклатуры КАК ВидНоменклатуры,
		|	СУММА(ПродажаТоваровПереченьНоменклатуры.Количество) КАК КоличествоВДокументе,
		|	СУММА(ПродажаТоваровПереченьНоменклатуры.Сумма) КАК СуммаВДокументе
		|ПОМЕСТИТЬ НоменклатураДокумента
		|ИЗ
		|	Документ.ПродажаТоваров.ПереченьНоменклатуры КАК ПродажаТоваровПереченьНоменклатуры
		|ГДЕ
		|	ПродажаТоваровПереченьНоменклатуры.Ссылка = &Ссылка
		|
		|СГРУППИРОВАТЬ ПО
		|	ПродажаТоваровПереченьНоменклатуры.Номенклатура,
		|	ПродажаТоваровПереченьНоменклатуры.Номенклатура.ВидНоменклатуры,
		|	ПродажаТоваровПереченьНоменклатуры.НаборСвойств";
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	РезультатЗапроса = Запрос.Выполнить();
	#КонецОбласти
	
#Область ДвиженияДокумента
	Запрос2 = Новый Запрос;
	Запрос2.МенеджерВременныхТаблиц = МенеджерВТ;
	Запрос2.Текст="ВЫБРАТЬ
	              |	НоменклатураДокумента.Номенклатура КАК Номенклатура,
	              |	НоменклатураДокумента.НаборСвойств КАК НаборСвойств,
	              |	НоменклатураДокумента.ВидНоменклатуры КАК ВидНоменклатуры,
	              |	НоменклатураДокумента.КоличествоВДокументе КАК КоличествоВДокументе,
	              |	НоменклатураДокумента.СуммаВДокументе КАК СуммаВДокументе,
	              |	ЕСТЬNULL(СтоимостьМатериаловОстатки.СтоимостьОстаток, 0) КАК Стоимость,
	              |	ЕСТЬNULL(ОстаткиМатериаловОстатки.КоличествоОстаток, 0) КАК Количество
	              |ИЗ
	              |	НоменклатураДокумента КАК НоменклатураДокумента
	              |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.СтоимостьМатериалов.Остатки(
	              |				,
	              |				Материал В
	              |					(ВЫБРАТЬ
	              |						НоменклатураДокумента.Номенклатура
	              |					ИЗ
	              |						НоменклатураДокумента)) КАК СтоимостьМатериаловОстатки
	              |		ПО НоменклатураДокумента.Номенклатура = СтоимостьМатериаловОстатки.Материал
	              |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ОстаткиМатериалов.Остатки(
	              |				,
	              |				Материал В
	              |					(ВЫБРАТЬ
	              |						НоменклатураДокумента.Номенклатура
	              |					ИЗ
	              |						НоменклатураДокумента)) КАК ОстаткиМатериаловОстатки
	              |		ПО НоменклатураДокумента.Номенклатура = ОстаткиМатериаловОстатки.Материал";
	
	
	  //Установим необходимость блокировки данных в регистрах СтоимостьМатериалов и ОстаткиМатериалов
Движения.СтоимостьМатериалов.БлокироватьДляИзменения = Истина;
Движения.ОстаткиМатериалов.БлокироватьДляИзменения = Истина;
		
	 //Запишем пустые наборы записей, чтобы читать остатки без учета данных в документе
Движения.СтоимостьМатериалов.Записать();
Движения.ОстаткиМатериалов.Записать();

	РезультатЗапроса = Запрос2.Выполнить();
	
	 //ТЗ = РезультатЗапроса.Выгрузить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		
		Если ВыборкаДетальныеЗаписи.Количество = 0 Тогда
СтоимостьМатериала = 0;
Иначе
СтоимостьМатериала = ВыборкаДетальныеЗаписи.Стоимость / ВыборкаДетальныеЗаписи.Количество;

КонецЕсли;

		Если ВыборкаДетальныеЗаписи.Номенклатура.ВидНоменклатуры = 
										Перечисления.ВидНоменклатуры.Материал Тогда
 //Регистр ОстаткиМатериалов Расход
Движение = Движения.ОстаткиМатериалов.Добавить();
Движение.ВидДвижения = ВидДвиженияНакопления.Расход;
Движение.Период = Дата;
Движение.Материал = ВыборкаДетальныеЗаписи.Номенклатура;
Движение.НаборСвойств = ВыборкаДетальныеЗаписи.НаборСвойств;
Движение.Склад = Склад;
Движение.Количество = ВыборкаДетальныеЗаписи.КоличествоВДокументе;

 //Регистр СтоимостьМатериалов Расход
Движение = Движения.СтоимостьМатериалов.Добавить();
Движение.ВидДвижения = ВидДвиженияНакопления.Расход;
Движение.Период = Дата;
Движение.Материал = ВыборкаДетальныеЗаписи.Номенклатура;
Движение.НаборСвойств = ВыборкаДетальныеЗаписи.НаборСвойств;
Движение.Стоимость = ВыборкаДетальныеЗаписи.КоличествоВДокументе * СтоимостьМатериала;
КонецЕсли;

 //Регистр Продажи
Движение = Движения.Продажи.Добавить();
Движение.Период = Дата;
Движение.Номенклатура = ВыборкаДетальныеЗаписи.Номенклатура;
Движение.НаборСвойств = ВыборкаДетальныеЗаписи.НаборСвойств;
Движение.Клиент = Клиент;
Движение.Кассир = Кассир;
Движение.Количество = ВыборкаДетальныеЗаписи.КоличествоВДокументе;
Движение.Выручка = ВыборкаДетальныеЗаписи.СуммаВДокументе;
Движение.Стоимость = СтоимостьМатериала *
										ВыборкаДетальныеЗаписи.КоличествоВДокументе;

 //Регистр Управленческий
// Первая проводка: Д 62(ДебиторскаяЗадолженность) – К 90 (Капитал) Розничная сумма
Движение = Движения.Управленческий.Добавить();
Движение.СчетДт = ПланыСчетов.Основной.ДебиторскаяЗадолженность;
Движение.СчетКт = ПланыСчетов.Основной.Капитал;
Движение.Период = Дата;
Движение.Сумма = ВыборкаДетальныеЗаписи.СуммаВДокументе;
Движение.СубконтоДт[ПланыВидовХарактеристик.ВидыСубконто.Клиенты] = Клиент;

// Вторая проводка: Д 90 (Капитал) – К 41 (Товары) – себестоимость
Движение = Движения.Управленческий.Добавить();
ДВижение.СчетДт = ПланыСчетов.Основной.Капитал;
Движение.СчетКт = ПланыСчетов.Основной.Товары;
Движение.Период = Дата;
Движение.Сумма = СтоимостьМатериала * ВыборкаДетальныеЗаписи.КоличествоВДокументе;
Движение.Количество = ВыборкаДетальныеЗаписи.КоличествоВДокументе;
Движение.СубконтоКт[ПланыВидовХарактеристик.ВидыСубконто.Материалы] = ВыборкаДетальныеЗаписи.Номенклатура;
КонецЦикла;

Движения.Записать();
#КонецОбласти

#Область КонтрольОстатков
Если Режим = РежимПроведенияДокумента.Оперативный Тогда
 //Проверить отрицательные остатки
Запрос3 = Новый Запрос;
Запрос3.МенеджерВременныхТаблиц = МенеджерВТ;
Запрос3.Текст = "ВЫБРАТЬ
                |	ОстаткиМатериаловОстатки.Материал КАК Материал,
				|	ОстаткиМатериаловОстатки.НаборСвойств,
                |	ОстаткиМатериаловОстатки.КоличествоОстаток КАК КоличествоОстаток
                |ИЗ
                |	РегистрНакопления.ОстаткиМатериалов.Остатки(, (Материал, НаборСвойств) В
                |			
                |					(ВЫБРАТЬ
                |						НоменклатураДокумента.Номенклатура,
				|						НоменклатураДокумента.НаборСвойств
                |					ИЗ
                |						НоменклатураДокумента)
                |				И Склад = &Склад) КАК ОстаткиМатериаловОстатки
                |ГДЕ
                |	ОстаткиМатериаловОстатки.КоличествоОстаток < 0";

Запрос3.УстановитьПараметр("Склад", Склад);
РезультатЗапроса = Запрос3.Выполнить();
ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
Сообщение = Новый СообщениеПользователю();
Сообщение.Текст = "Не хватает " + Строка(- ВыборкаДетальныеЗаписи.КоличествоОстаток) +
 " единиц материала """ + ВыборкаДетальныеЗаписи.Материал + """" + "из набора свойства""" + ВыборкаДетальныеЗаписи.НаборСвойств + """";
Сообщение.Сообщить();
Отказ = Истина;

КонецЦикла;

КонецЕсли;
#КонецОбласти

КонецПроцедуры
Процедура ПриУстановкеНовогоНомера(СтандартнаяОбработка, Префикс)
	
Префикс = Обмен.ПолучитьПрефиксНомера();

КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	//{{__КОНСТРУКТОР_ВВОД_НА_ОСНОВАНИИ
	// Данный фрагмент построен конструктором.
	// При повторном использовании конструктора, внесенные вручную изменения будут утеряны!!!
	Если ТипЗнч(ДанныеЗаполнения) = Тип("СправочникСсылка.Клиенты") Тогда
		// Заполнение шапки
		Клиент = ДанныеЗаполнения.Ссылка;
	КонецЕсли;
	//}}__КОНСТРУКТОР_ВВОД_НА_ОСНОВАНИИ
КонецПроцедуры
