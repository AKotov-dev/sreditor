��          �      <      �     �     �  G   �     ,  �   :  _   *  J   �  i   �     ?     X  (   o  @   �  q   �     K  %   [     �     �  �   �  '   �  B   �  `     &   {  9  �  �   �  W   e	  �   �	  +   M
  ,   y
  X   �
  x   �
  �   x       N   "     q     �                                        
                   	                                          1) USB Devices list: 2) Rule to insert, or a hint: 3) This program writes the rules to /etc/udev/rules.d/60-libsane.rules: Add and Apply Automatic addition of rules
 
License: GPLv3
Compilation: Lazarus 2.2.0
Author: alex_q_2000 (C) 2021
 
URL: https://github.com/AKotov-dev/sreditor
 
Gratitude:
Morgan Leijström, David GEIGER,
Thomas Backlund, Aurelien Oudelet, Lewis Smith Don't forget to add the user to the desired groups::
usermod -aG usb,scanner $(logname); reboot License: GPLv3   Author: alex_q_2000 (C) 2021   URL: https://linuxforum.ru Loads the default rules from
/lib/udev/rules.d/60-libsane.rules or
/usr/lib/udev/rules.d/60-libsane.rules No devices were found... Restart your computer. Specify your scanner and click "Add" (+) The device is already in the list of rules. No action is needed. The main rules file was not found:
/lib/udev/rules.d/60-libsane.rules or 
/usr/lib/udev/rules.d/60-libsane.rules! Update the list Your changes will be reset! Continue? taboutform.captionAbout tmainform.aboutbtn.hintAbout Project-Id-Version: 
PO-Revision-Date: 
Last-Translator: 
Language-Team: 
Language: ru
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Plural-Forms: nplurals=2; plural=(n != 1);
X-Generator: Poedit 3.2.2
 1) Список USB-устройств: 2) Правило для вставки или подсказка: 3) Программа записывает правила в /etc/udev/rules.d/60-libsane.rules: Добавить и Применить Автоматическое добавление правил
 
Лицензия: GPLv3
Компиляция: Lazarus 2.2.0
Автор: alex_q_2000 (C) 2021
 
URL: https://github.com/AKotov-dev/sreditor
 
Благодарность:
Morgan Leijström, David GEIGER,
Thomas Backlund, Aurelien Oudelet, Lewis Smith Не забудьте включить пользователя в нужные группы:
usermod -aG usb,scanner $(logname); reboot Лицензия: GPLv3   Автор: alex_q_2000 (C) 2021   URL: https://linuxforum.ru Загрузить правила по умолчанию из
/lib/udev/rules.d/60-libsane.rules или
/usr/lib/udev/rules.d/60-libsane.rules Устройства не найдены... Перзагрузите компьютер. Укажите Ваш сканер и нажмите кнопку "Добавить" (+) Устройство уже существует в списке правил. Действий не требуется. Основной файл правил не найден:
/lib/udev/rules.d/60-libsane.rules или
/usr/lib/udev/rules.d/60-libsane.rules! Обновить список Ваши изменения будут сброшены! Продолжить? О программе О программе 