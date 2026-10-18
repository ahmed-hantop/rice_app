// presentation/widgets/pod_card.dart
import 'package:flutter/material.dart';
import 'package:rice_delivery/core/constants/app_colors.dart';
import '../../providers/pod_form_controller.dart';
import 'photo_viewfinder.dart';
import 'quality_checkbox.dart';

class PodCard extends StatelessWidget {
  const PodCard({
    super.key,
    required this.form,
    required this.imagePath,
    required this.onNotes,
    required this.onToggleTemp,
    required this.onToggleSms,
    required this.onSubmit,
  });

  final PodFormState form;
  final String imagePath;
  final VoidCallback onToggleTemp, onToggleSms, onSubmit;
  final ValueChanged<String> onNotes;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border.withOpacity(0.7)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.field,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.green.withOpacity(0.3)),
                ),
                child: const Icon(Icons.verified_outlined,
                    color: AppColors.green, size: 20),
              ),
              const SizedBox(width: 10),
              const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Proof of Delivery',
                    style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w800, color: Colors.white)),
                Text('Step 2 of 2: Package Handoff',
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: AppColors.muted)),
              ]),
            ]),
            const SizedBox(height: 14),
            PhotoViewfinder(
              photoPath:imagePath,
              location: form.location,
              
            ),
            const SizedBox(height: 14),
            const Row(children: [
              Icon(Icons.notes_rounded, size: 15, color: AppColors.muted),
              SizedBox(width: 6),
              Text('Drop-off location notes',
                  style: TextStyle(
                      fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.muted)),
            ]),
            const SizedBox(height: 8),
            _NotesField(onChanged: onNotes),
            const SizedBox(height: 14),
            Row(children: [
              Expanded(
                child: QualityCheckbox(
                  label: 'Temp OK',
                  sublabel: 'Cold chain intact',
                  checked: form.tempOk,
                  onTap: onToggleTemp,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: QualityCheckbox(
                  label: 'SMS Notified',
                  sublabel: 'Delivery ping sent',
                  checked: form.smsNotified,
                  onTap: onToggleSms,
                ),
              ),
            ]),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: form.canSubmit ? onSubmit : null,
                icon: form.submitting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                            strokeWidth: 2.5, color: AppColors.onGreen))
                    : const Icon(Icons.check_circle_outline_rounded, size: 20),
                label: const Text('SUBMIT PROOF & COMPLETE ORDER',
                    style: TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w800, letterSpacing: 0.3)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.green,
                  foregroundColor: AppColors.onGreen,
                  disabledBackgroundColor: AppColors.green.withOpacity(0.3),
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
            if (!form.canSubmit && !form.submitting)
              const Padding(
                padding: EdgeInsets.only(top: 8),
                child: Center(
                  child: Text('Confirm arrival and take a photo to continue.',
                      style: TextStyle(fontSize: 11, color: AppColors.muted)),
                ),
              ),
          ],
        ),
      );
}

class _NotesField extends StatefulWidget {
  const _NotesField({required this.onChanged});
  final ValueChanged<String> onChanged;

  @override
  State<_NotesField> createState() => _NotesFieldState();
}

class _NotesFieldState extends State<_NotesField> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: AppColors.field,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.border.withOpacity(0.8)),
        ),
        child: Row(children: [
          Expanded(
            child: TextField(
              controller: _controller,
              onChanged: widget.onChanged,
              maxLines: 2,
              minLines: 1,
              style: const TextStyle(
                  color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'e.g. Left at the door next to the mat',
                hintStyle: TextStyle(color: AppColors.hint, fontSize: 13),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close_rounded, size: 16, color: AppColors.muted),
            onPressed: () {
              _controller.clear();
              widget.onChanged('');
            },
          ),
        ]),
      );
}