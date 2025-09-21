# FAQ - Часто задаваемые вопросы

Самые популярные вопросы и ответы по Flutter Magento Plugin 2.0.

## 🚀 Общие вопросы

### В чем отличие версии 2.0 от предыдущих версий?

Flutter Magento Plugin 2.0 представляет собой полную переработку архитектуры с фокусом на:

- **Унификацию** - один API для всех типов приложений
- **Универсальные кастомные атрибуты** - поддержка любых типов данных
- **Производительность** - улучшение на 300%
- **Типобезопасность** - строгая типизация с Freezed
- **Расширенный офлайн режим** - полная функциональность без интернета

### Поддерживает ли плагин все платформы Flutter?

Да, плагин поддерживает все платформы:

| Платформа | Статус | Минимальная версия |
|-----------|--------|--------------------|
| Android | ✅ Полная поддержка | API 21 (Android 5.0) |
| iOS | ✅ Полная поддержка | iOS 12.0 |
| Web | ✅ Полная поддержка | Современные браузеры |
| Windows | ✅ Полная поддержка | Windows 10 |
| macOS | ✅ Полная поддержка | macOS 10.14 |
| Linux | ✅ Полная поддержка | Ubuntu 18.04+ |

### Какие версии Magento поддерживаются?

Плагин поддерживает:
- **Magento 2.4.0+** (рекомендуется 2.4.6+)
- **Magento Commerce** и **Open Source**
- **Adobe Commerce Cloud**

## 🔧 Установка и настройка

### Как установить плагин?

```yaml
dependencies:
  flutter_magento: ^2.8.0
```

Затем выполните:
```bash
flutter pub get
```

### Получаю ошибку при инициализации. Что делать?

Проверьте следующее:

1. **URL магазина** корректен и доступен
2. **Настройки CORS** в Magento (для веб)
3. **SSL сертификат** валиден
4. **REST API** включен в Magento

```dart
// Для отладки включите логирование
await magento.initialize(
  baseUrl: 'https://your-store.com',
  enableDebugLogging: true,
);
```

### Как настроить CORS для веб-приложений?

В Magento добавьте настройки CORS:

```php
// app/etc/di.xml
<type name="Magento\Framework\App\Response\Http">
    <plugin name="cors_headers" type="Your\Module\Plugin\CorsHeaders"/>
</type>
```

Или используйте расширение для Magento 2 CORS.

### Ошибка SSL сертификата в разработке

**Только для разработки:**

```dart
import 'dart:io';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}

void main() {
  HttpOverrides.global = MyHttpOverrides();
  runApp(MyApp());
}
```

## 🔐 Аутентификация

### Как работает автоматическое обновление токенов?

Плагин автоматически:
1. Сохраняет JWT токены в безопасном хранилище
2. Проверяет срок действия перед каждым запросом
3. Обновляет токены при необходимости
4. Уведомляет о проблемах с токенами

### Поддерживается ли социальная аутентификация?

Да, поддерживаются:
- **Google Sign-In**
- **Facebook Login**
- **Apple Sign-In**

Требуется дополнительная настройка провайдеров.

### Как реализовать "Запомнить меня"?

```dart
final authResponse = await magento.auth.authenticateCustomer(
  email: 'user@example.com',
  password: 'password',
  rememberMe: true, // Токен будет действовать 90 дней
);
```

## 🛍️ Продукты и каталог

### Как получить продукты с фильтрами?

```dart
final products = await magento.products.getProducts(
  filters: {
    'category_id': '123',
    'price': {'gt': '10.00', 'lt': '100.00'},
    'status': '1',
  },
  sortBy: 'price',
  sortOrder: 'asc',
  page: 1,
  pageSize: 20,
);
```

### Поддерживаются ли конфигурируемые продукты?

Да, плагин полностью поддерживает:
- Простые продукты
- Конфигурируемые продукты
- Сгруппированные продукты
- Виртуальные продукты
- Загружаемые продукты

### Как работать с кастомными атрибутами?

Используйте универсальную систему кастомных атрибутов:

```dart
// Создайте адаптер для ваших атрибутов
class MyCustomAdapter extends CustomAttributesAdapter<MyCustomAttributes> {
  // ... реализация
}

// Используйте типизированные продукты
final products = await magento.enhancedProducts.getEnhancedProducts<MyCustomAttributes>(
  adapterId: 'my_adapter',
);
```

## 🛒 Корзина и заказы

### Как работать с корзиной гостя?

```dart
// Создание корзины для гостя
final cart = await magento.cart.createCart();

// Добавление товаров
await magento.cart.addToCart(
  cartId: cart.id!,
  sku: 'product-sku',
  quantity: 1,
);
```

### Как перенести корзину гостя авторизованному пользователю?

```dart
// После авторизации
await magento.cart.mergeGuestCart(guestCartId, customerCartId);
```

### Поддерживаются ли купоны?

Да:

```dart
// Применение купона
await magento.cart.applyCoupon(
  cartId: cart.id!,
  couponCode: 'SAVE20',
);

// Удаление купона
await magento.cart.removeCoupon(cart.id!);
```

## 📱 Офлайн режим

### Как работает офлайн режим?

Плагин автоматически:
1. **Кэширует** данные в локальной базе
2. **Сохраняет** операции в очередь
3. **Синхронизирует** при восстановлении сети
4. **Разрешает конфликты** данных

### Можно ли настроить кэширование?

```dart
await magento.initialize(
  baseUrl: 'https://your-store.com',
  cacheConfig: CacheConfig(
    enableCaching: true,
    cacheDuration: Duration(minutes: 30),
    maxCacheSize: 100 * 1024 * 1024, // 100MB
  ),
);
```

### Какие операции работают офлайн?

- Просмотр кэшированных продуктов
- Добавление в корзину (с синхронизацией)
- Просмотр истории заказов
- Поиск по кэшированным данным

## 🌐 Локализация

### Сколько языков поддерживается?

Плагин поддерживает **45+ языков** из коробки, включая:
- Английский, Русский, Немецкий, Французский
- Испанский, Итальянский, Португальский
- Китайский, Японский, Корейский
- Арабский, Иврит (с RTL поддержкой)

### Как добавить кастомные переводы?

```dart
await magento.initialize(
  baseUrl: 'https://your-store.com',
  localizationConfig: LocalizationConfig(
    customTranslations: {
      'en': {'custom_key': 'Custom Value'},
      'ru': {'custom_key': 'Кастомное значение'},
    },
  ),
);
```

## ⚡ Производительность

### Как оптимизировать производительность?

1. **Включите кэширование:**
```dart
cacheConfig: CacheConfig(enableCaching: true)
```

2. **Используйте пагинацию:**
```dart
final products = await magento.products.getProducts(
  page: 1,
  pageSize: 20, // Не больше 50
);
```

3. **Загружайте изображения лениво:**
```dart
CachedNetworkImage(
  imageUrl: product.imageUrl,
  placeholder: (context, url) => CircularProgressIndicator(),
)
```

4. **Используйте виртуализацию для длинных списков:**
```dart
ListView.builder(
  itemCount: products.length,
  itemBuilder: (context, index) => ProductTile(products[index]),
)
```

### Почему медленно загружаются продукты?

Возможные причины:
- Слишком большой размер страницы (`pageSize`)
- Медленная сеть или сервер
- Отключено кэширование
- Большие изображения без оптимизации

## 🔒 Безопасность

### Как обеспечивается безопасность данных?

- **AES-256** шифрование для локальных данных
- **HTTPS** принудительно для всех запросов
- **JWT токены** с автоматическим обновлением
- **FlutterSecureStorage** для чувствительных данных
- **Валидация входных данных**

### Что делать при утечке токенов?

```dart
// Немедленно аннулируйте все токены
await magento.auth.revokeAllTokens();

// Принудительно выйдите из всех сессий
await magento.auth.logoutFromAllDevices();

// Смените пароль
await magento.auth.changePassword(oldPassword, newPassword);
```

## 🧪 Тестирование

### Как тестировать приложение с плагином?

```dart
// Используйте моки для тестирования
class MockMagento extends Mock implements FlutterMagento {}

void main() {
  group('Auth Tests', () {
    late MockMagento mockMagento;
    
    setUp(() {
      mockMagento = MockMagento();
    });
    
    test('should login successfully', () async {
      when(() => mockMagento.auth.authenticateCustomer(
        email: any(named: 'email'),
        password: any(named: 'password'),
      )).thenAnswer((_) async => mockAuthResponse);
      
      final result = await authService.login('test@example.com', 'password');
      expect(result, isTrue);
    });
  });
}
```

### Есть ли готовые тестовые данные?

Да, используйте демо-магазин:
```dart
await magento.initialize(
  baseUrl: 'https://magento2-demo.magebit.com',
);
```

## 🔧 Разработка и отладка

### Как включить отладочные логи?

```dart
await magento.initialize(
  baseUrl: 'https://your-store.com',
  enableDebugLogging: true,
);

// Или для кастомных атрибутов
magento.enableCustomAttributesDebugLogging = true;
```

### Как создать кастомный адаптер?

1. Создайте модель данных с `@freezed`
2. Наследуйтесь от `CustomAttributesAdapter<T>`
3. Реализуйте необходимые методы
4. Зарегистрируйте адаптер при инициализации

Подробнее в [документации по кастомным атрибутам](../custom-attributes/creating-adapters.md).

### Как отлаживать сетевые запросы?

```dart
// Используйте Dio interceptor
await magento.initialize(
  baseUrl: 'https://your-store.com',
  dioInterceptors: [
    LogInterceptor(
      requestBody: true,
      responseBody: true,
    ),
  ],
);
```

## 📊 Мониторинг и аналитика

### Как отслеживать производительность?

```dart
// Включите мониторинг производительности
await magento.initialize(
  baseUrl: 'https://your-store.com',
  performanceConfig: PerformanceConfig(
    enablePerformanceMonitoring: true,
    trackNetworkRequests: true,
    trackCacheHitRate: true,
  ),
);

// Получите метрики
final metrics = await magento.getPerformanceMetrics();
print('Скорость ответа API: ${metrics.averageResponseTime}ms');
print('Коэффициент попадания в кэш: ${metrics.cacheHitRate}%');
```

### Поддерживается ли аналитика?

Да, плагин интегрируется с:
- Google Analytics
- Firebase Analytics
- Adobe Analytics
- Кастомные аналитические системы

## 🤝 Сообщество и поддержка

### Где получить помощь?

1. **Документация** - [GitBook](../README.md)
2. **GitHub Issues** - [Создать issue](https://github.com/nativemind/flutter_magento/issues)
3. **Discord сообщество** - [Присоединиться](https://discord.gg/nativemind)
4. **Email поддержка** - support@nativemind.net

### Как внести вклад в проект?

1. Сделайте fork репозитория
2. Создайте feature branch
3. Внесите изменения и добавьте тесты
4. Создайте Pull Request

Подробнее в [CONTRIBUTING.md](../development/contributing.md).

### Планируется ли поддержка Magento 1.x?

Нет, плагин поддерживает только Magento 2.x. Magento 1.x достиг конца жизни и не рекомендуется для новых проектов.

## 🔄 Миграция и обновление

### Как мигрировать с версии 1.x?

Следуйте [руководству по миграции](../getting-started/migration.md):

1. Обновите зависимости
2. Измените API вызовы
3. Обновите модели данных
4. Протестируйте функциональность

### Обратная совместимость поддерживается?

Частично. Основные API изменились, но предоставлен миграционный гид и инструменты для упрощения перехода.

### Как часто выходят обновления?

- **Мажорные релизы** - раз в 6-12 месяцев
- **Минорные релизы** - ежемесячно
- **Патчи** - по мере необходимости

---

## 💡 Не нашли ответ?

Если ваш вопрос не освещен в FAQ:

1. Проверьте [полную документацию](../README.md)
2. Поищите в [GitHub Issues](https://github.com/nativemind/flutter_magento/issues)
3. Задайте вопрос в [Discord сообществе](https://discord.gg/nativemind)
4. Создайте новый issue с тегом `question`

**Мы постоянно обновляем FAQ на основе вопросов сообщества!**
