
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactScreen extends StatefulWidget {
  final bool initialOperativeRequest;

  const ContactScreen({super.key, this.initialOperativeRequest = false});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _nameController = TextEditingController();
  final _emailController = TextEditingController(); // Added for "Hablemos" compatibility
  final _phoneController = TextEditingController();
  final _communeController = TextEditingController(); // Specific to Operative
  final _messageController = TextEditingController(); // General message

  // Toggle for "Type of Contact"
  late bool _isOperativeRequest;

  @override
  void initState() {
    super.initState();
    _isOperativeRequest = widget.initialOperativeRequest;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _communeController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contáctanos'),
      ), // Optional: Shell might handle AppBar
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Banner / Header (Optional, reused from OperativeRequest or just simple)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
              color: Colors.grey[50],
              child: const Column(
                children: [
                  Text('Estamos aquí para ayudarte', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Text('Resuelve tus dudas o solicita un operativo oftalmológico para tu comunidad.', 
                       textAlign: TextAlign.center, style: TextStyle(color: Colors.grey, fontSize: 16)),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isDesktop = constraints.maxWidth > 900;
                  return Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1200),
                      child: isDesktop 
                          ? Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(child: _buildContactInfo(context)),
                                const SizedBox(width: 60),
                                Expanded(child: _buildContactForm(context)),
                              ],
                            )
                          : Column(
                              children: [
                                _buildContactInfo(context),
                                const SizedBox(height: 60),
                                _buildContactForm(context),
                              ],
                            ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Map Placeholder
        Container(
          height: 300,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(20),
            image: const DecorationImage(
              image: NetworkImage('https://maps.googleapis.com/maps/api/staticmap?center=-33.4372, -70.6506&zoom=15&size=600x300&maptype=roadmap&markers=color:red%7Clabel:S%7C-33.4372, -70.6506&key=YOUR_API_KEY'), // Placeholder
              fit: BoxFit.cover,
            ),
          ),
          child: const Center(
            child: Icon(Icons.location_on, size: 50, color: Colors.redAccent),
          ),
        ),
        const SizedBox(height: 40),
        
        _buildInfoRow(Icons.location_on_outlined, 'Mac Iver #180 Of. 34', 'Santiago Centro'),
        const SizedBox(height: 20),
        _buildInfoRow(Icons.email_outlined, 'opticasferreira.santiago@gmail.com', 'Escríbenos para cotizar'),
        const SizedBox(height: 20),
        _buildInfoRow(Icons.phone_outlined, '+56 9 5112 6491', 'Lunes a Viernes 9:00 - 18:00'),
        const SizedBox(height: 40),

        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _buildSocialIcon(Icons.facebook),
            const SizedBox(width: 15),
            _buildSocialIcon(Icons.camera_alt), // Instagram placeholder
            const SizedBox(width: 15),
            _buildSocialIcon(Icons.video_library), // Tiktok placeholder
            const SizedBox(width: 15),
            _buildSocialIcon(Icons.close), // X placeholder
          ],
        )
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String title, String subtitle) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: const Color(0xFF009B77).withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
          child: Icon(icon, color: const Color(0xFF009B77), size: 28)
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 4),
              Text(subtitle, style: const TextStyle(color: Colors.grey)),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildSocialIcon(IconData icon) {
    return InkWell(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 20, color: Colors.grey[700]), 
      ),
    );
  }

  Widget _buildContactForm(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, 10))
        ]
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Toggle Section
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => setState(() => _isOperativeRequest = false),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(color: !_isOperativeRequest ? const Color(0xFF009B77) : Colors.grey[200]!, width: 3))
                      ),
                      child: Text('Consulta General', 
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold, color: !_isOperativeRequest ? const Color(0xFF009B77) : Colors.grey)
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () => setState(() => _isOperativeRequest = true),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(color: _isOperativeRequest ? const Color(0xFF009B77) : Colors.grey[200]!, width: 3))
                      ),
                      child: Text('Solicitar Operativo', 
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold, color: _isOperativeRequest ? const Color(0xFF009B77) : Colors.grey)
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),

            const Text('HABLEMOS', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
            const SizedBox(height: 10),
            Text(_isOperativeRequest ? 'Organiza un operativo oftalmológico en tu comunidad.' : 'Déjanos tus datos y te contactaremos.', style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 30),
            
            _buildTextField(_nameController, 'Nombre completo', Icons.person_outline),
            const SizedBox(height: 20),
            
            // Layout changes based on type
            Row(
              children: [
                Expanded(child: _buildTextField(_phoneController, 'Teléfono', Icons.phone_outlined)),
                const SizedBox(width: 15),
                Expanded(child: _buildTextField(_emailController, 'Email', Icons.email_outlined)),
              ],
            ),
            const SizedBox(height: 20),

            if (_isOperativeRequest) ...[
               _buildTextField(_communeController, 'Comuna / Dirección', Icons.map_outlined),
               const SizedBox(height: 20),
            ],

            _buildTextField(_messageController, _isOperativeRequest ? 'Detalles (Cant. personas, lugar, etc.)' : 'Mensaje o Consulta', Icons.chat_bubble_outline, maxLines: 4),
            
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _sendMessage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF009B77), // Turquoise/Mint
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: Text(_isOperativeRequest ? 'SOLICITAR OPERATIVO' : 'ENVIAR MENSAJE', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint, IconData icon, {int maxLines = 1}) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      validator: (v) => v!.isEmpty ? 'Campo requerido' : null,
      decoration: InputDecoration(
        labelText: hint,
        labelStyle: TextStyle(color: Colors.grey[600], fontSize: 14),
        prefixIcon: Icon(icon, color: Colors.grey[400], size: 20),
        filled: true,
        fillColor: Colors.grey[50], // Slightly gray bg
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[200]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: const Color(0xFF009B77).withOpacity(0.5)),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      ),
    );
  }

  Future<void> _sendMessage() async {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text;
      final phone = _phoneController.text;
      final email = _emailController.text;
      final msg = _messageController.text;
      final commune = _communeController.text;

      String whatsappMsg = '';
      if (_isOperativeRequest) {
        whatsappMsg = 'Hola Su Óptica! Quisiera solicitar un operativo.\n\n*Solicitante:* $name\n*Tel:* $phone\n*Email:* $email\n*Lugar:* $commune\n*Detalles:* $msg';
      } else {
        whatsappMsg = 'Hola Su Óptica! Tengo una consulta.\n\n*Nombre:* $name\n*Tel:* $phone\n*Email:* $email\n*Mensaje:* $msg';
      }

      final url = 'https://wa.me/56944290263?text=${Uri.encodeComponent(whatsappMsg)}';
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url));
      }
    }
  }
}
