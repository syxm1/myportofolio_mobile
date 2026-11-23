import 'package:flutter/material.dart';

class PortfolioDateField extends FormField<DateTime> {
  PortfolioDateField({
    super.key,
    required String label,
    required ValueChanged<DateTime> onChanged,
    super.validator,
  }) : super(
         builder: (field) {
           final value = field.value;
           return InkWell(
             onTap: () async {
               final selected = await showDatePicker(
                 context: field.context,
                 initialDate: value ?? DateTime.now(),
                 firstDate: DateTime(1950),
                 lastDate: DateTime(2100),
               );
               if (selected != null && field.context.mounted) {
                 field.didChange(selected);
                 onChanged(selected);
               }
             },
             child: InputDecorator(
               decoration: InputDecoration(
                 labelText: label,
                 border: const OutlineInputBorder(),
                 errorText: field.errorText,
                 suffixIcon: const Icon(Icons.calendar_today),
               ),
               child: Text(
                 value == null
                     ? 'Pilih tanggal'
                     : '${value.day}/${value.month}/${value.year}',
               ),
             ),
           );
         },
       );
}
