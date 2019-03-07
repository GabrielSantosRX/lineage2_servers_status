import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:lineage2_servers_status/screens/list_screen.dart';

void main() {
  testWidgets('Show List Screen', (WidgetTester tester) async {

    await tester.pumpWidget(MaterialApp(home: ListScreen(title: 'teste')));
    
    //const Key mainKey = Key('Main');
    //const Key _aboutButtonKey = Key('AboutButton');
    await tester.tap(find.byKey(Key('AboutButton')));
    //final L2ssApp mainApp = L2ssApp();
    //final ListScreen listScreen = ListScreen(title: 'teste');
    //await tester.pumpWidget(mainApp);

    //var elemento = find.text('Lineage 2 Servers Status');
    //var elemento = find.byKey(Key('ListTileServers'));
    //print(elemento);
    //expect(find.byKey(listServersKey), findsOneWidget);

    //for (var item in tester.allWidgets) {
      //print(item.toString());
    //}

    //const ListScreen listScreenWidget = ListScreen(key: listServersKey, title: 'Teste');
    

    //final Offset target = tester.getCenter(find.byKey(listServersKey));
    //final TestGesture gesture = await tester.startGesture(target);
    //await gesture.moveBy(const Offset(0.0, -10.0));

    //await tester.pump(const Duration(milliseconds: 1));
    // Verify that our counter starts at 0.
    //expect(find.byKey(listServersKey), findsOneWidget);

    // Tap the '+' icon and trigger a frame.
    //await tester.tap(find.byKey(key) .byIcon(Icons.add));
    //await tester.pump();

    // Verify that our counter has incremented.
    //expect(find.text('0'), findsNothing);
    //expect(find.text('1'), findsOneWidget);
  });
}
