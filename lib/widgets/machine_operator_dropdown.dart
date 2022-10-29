import 'package:flutter/material.dart';
import 'package:recipe_management/entities.dart';

class MachineOperatorDropDownButton extends StatefulWidget {
  final Stream<List<MachineOperator>> machineOperatorStream;
  final void Function(MachineOperator? machineOperator)? onChanged;
  MachineOperator? selectedMachineOperator;

  MachineOperatorDropDownButton({
    Key? key,
    required this.machineOperatorStream,
    required this.selectedMachineOperator,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<MachineOperatorDropDownButton> createState() =>
      _MachineOperatorDropDownButtonState();
}

class _MachineOperatorDropDownButtonState
    extends State<MachineOperatorDropDownButton> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<MachineOperator>>(
      stream: widget.machineOperatorStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return DropdownButton<MachineOperator>(
            value: widget.selectedMachineOperator,
            items: snapshot.data
                ?.map<DropdownMenuItem<MachineOperator>>((MachineOperator e) {
              return DropdownMenuItem(
                  value: e,
                  child: Card(
                    color: Colors.indigo,
                    elevation: 6.0,
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            '${e.firstName} ${e.lastName}',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            e.email,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ));
            }).toList(),
            onChanged: widget.onChanged,
            // onChanged: (value) {
            //   setState(() {
            //     widget.selectedMachineOperator = value;
            //   });
            // },
          );
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}

// Widget genericDropDown<T>({
//   required BuildContext context,
//   required Stream<List<T>> stream,
//   required T selected,
// }) {
//   return StreamBuilder<List<T>>(
//     stream: stream,
//     builder: (context, snapshot) {
//       if (snapshot.hasData) {
//         return DropdownButton<T>(
//           value: selected,
//           items: snapshot.data?.map<DropdownMenuItem<T>>((T e) {
//             return DropdownMenuItem(value: e, child: Text(e.toString()));
//           }).toList(),
//           onChanged: (value) {
//             selected = value as T;
//           },
//         );
//       } else {
//         return const CircularProgressIndicator();
//       }
//     },
//   );
// }
