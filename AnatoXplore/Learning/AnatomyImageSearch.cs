using System;
using System.Collections.Generic;
using System.Web;
using System.Web.Script.Serialization;

namespace AnatoXplore.Learning
{
    // Curated OpenStax figures keyed to the structure lesson IDs in the four Learning pages.
    // Keeping this catalog local avoids unrelated or mismatched search results at runtime.
    public sealed class AnatomyImageSearch : IHttpHandler
    {
        private sealed class Illustration
        {
            public readonly string ImageUrl;
            public readonly string SourceUrl;
            public readonly string Caption;
            public Illustration(string imageId, string sourceUrl, string caption)
            {
                ImageUrl = "https://openstax.org/apps/image-cdn/v1/f%3Dwebp/apps/archive/20260604.144757/resources/" + imageId;
                SourceUrl = sourceUrl;
                Caption = caption;
            }
        }

        private const string Book2 = "Anatomy and Physiology 2e";
        private const string Book1 = "Anatomy and Physiology";
        private const string NursingBook = "Clinical Nursing Skills";
        private const string License = "CC BY-NC-SA 4.0";
        private const string Base2 = "https://openstax.org/books/anatomy-and-physiology-2e/pages/";
        private const string Base1 = "https://openstax.org/books/anatomy-and-physiology/pages/";
        private static readonly IDictionary<string, IDictionary<string, Illustration>> Catalog = BuildCatalog();

        private static IDictionary<string, IDictionary<string, Illustration>> BuildCatalog()
        {
            var catalog = new Dictionary<string, IDictionary<string, Illustration>>(StringComparer.OrdinalIgnoreCase);
            catalog["skeletal"] = Entries(
                E("skull", "895d7b163601cb5362535f474cf0ce46a88133d6", Base2 + "7-2-the-skull", "Figure 7.3, Parts of the Skull", Book2),
                E("spine", "408a4ed7f3a629c9a7e2e08b8544ca3d5ff055c3", Base2 + "7-3-the-vertebral-column", "Figure 7.20, The Vertebral Column", Book2),
                E("ribcage", "e1cbee95a6b2d98480a003a7bc69809a859173d9", Base1 + "7-4-the-thoracic-cage", "Figure 7.32, The Thoracic Cage", Book1),
                E("shoulder", "80224ef3967f0d62672cd00db90e8b15ffb1dfff", Base2 + "8-1-the-pectoral-girdle", "Figure 8.3, The Pectoral Girdle", Book2),
                E("arms", "5f70593eab8f8ab3ebf4aa75fc37d72225c0a95d", Base2 + "8-2-bones-of-the-upper-limb", "Figure 8.5, Bones of the Upper Limb", Book2),
                E("pelvis", "7d950c0b25db457d4f3a08355276d34cbbf8c30f", Base2 + "8-3-the-pelvic-girdle-and-pelvis", "Figure 8.12, The Pelvis", Book2),
                E("legs", "6e59c1693b3349bffa2c27ac7a2e29f889a08edc", Base2 + "8-4-bones-of-the-lower-limb", "Figure 8.16, Bones of the Lower Limb", Book2),
                E("joints", "c13e0675f88df80a649c4b816686318261b55b45", Base1 + "9-4-synovial-joints", "Figure 9.10, Types of Synovial Joints", Book1));

            catalog["muscular"] = Entries(
                E("head-muscles", "9b369a7466ec2ef44a97decc8de15593c7189e13", Base1 + "11-3-axial-muscles-of-the-head-neck-and-back", "Figure 11.7, Muscles of Facial Expression", Book1),
                E("neck-muscles", "c6b4c0fc14243be85bfe162be2b6cf0a1a39eede", Base2 + "11-3-axial-muscles-of-the-head-neck-and-back", "Figure 11.14, Muscles of the Neck", Book2),
                E("chest-muscles", "6525f9910f98dcfa17b17f859e30bc46b9357d16", Base1 + "11-4-axial-muscles-of-the-abdominal-wall-and-thorax", "Figure 11.18, Intercostal Muscles", Book1),
                E("back-muscles", "761ef0480a9314d65cdb9d273848849c93e28dfc", Base2 + "11-3-axial-muscles-of-the-head-neck-and-back", "Figure 11.15, Muscles of the Neck and Back", Book2),
                E("upper-limb", "6668b272a691b8377071de429a1336fec0469a5c", Base2 + "11-5-muscles-of-the-pectoral-girdle-and-upper-limbs", "Figure 11.25, Muscles That Move the Forearm", Book2),
                E("lower-limb", "48a26b0c6351a2052a16c4fcd338bc092505e492", Base1 + "11-6-appendicular-muscles-of-the-pelvic-girdle-and-lower-limbs", "Figure 11.29, Muscles of the Hip and Thigh", Book1),
                E("tendons", "f9805d8da52c844b737fa142e36a9be9c24d2b93", "https://openstax.org/books/clinical-nursing-skills/pages/25-1-structure-and-function", "Figure 25.6, Muscles, Tendons, and Ligaments of the Lower Leg", NursingBook),
                E("fascia-ligaments", "e9efe6bbd9bf0d4f3a083a7bc69809a859173d9", Base2 + "8-3-the-pelvic-girdle-and-pelvis", "Figure 8.14, Ligaments of the Pelvis", Book2));

            catalog["nervous"] = Entries(
                E("central-brain", "8f2bb6eaf9e5b57aa56c5679502525b6815c36a7", Base2 + "13-2-the-central-nervous-system", "Figure 13.6, The Cerebrum", Book2),
                E("central-spinal-cord", "c6ce3f728a80e735cbb42aaf4a4216484a353be4", Base2 + "13-2-the-central-nervous-system", "Figure 13.14, Cross-Section of the Spinal Cord", Book2),
                E("peripheral-cranial", "0301c86d5b037f2400c0bf1f32466c60cd8d93ee", Base2 + "13-4-the-peripheral-nervous-system", "Figure 13.23, Cranial Nerves", Book2),
                E("peripheral-spinal", "52d03bc6b3572cb7b46923c2c136ffe4bc48d53d", Base2 + "13-4-the-peripheral-nervous-system", "Figure 13.24, Nerve Plexuses", Book2),
                E("neuron-structure", "5eb1ce492d604faad88e5b8b096fc7ac4a8fcb8f", Base1 + "12-2-nervous-tissue", "Figure 12.8, Parts of a Neuron", Book1),
                E("synapses", "75ab19a5b7c2945555083964780a2159caa68856", Base1 + "12-5-communication-between-neurons", "Figure 12.27, The Synapse", Book1),
                E("sensory-vision", "53d521afbb00a18877d8ff7c2d82a4dc48f0654d", Base2 + "14-1-sensory-perception", "Figure 14.15, Structure of the Eye", Book2),
                E("sensory-hearing", "dd97d7920818a0a5b338a427a1d846043b156238", Base2 + "14-1-sensory-perception", "Figure 14.5, Structures of the Ear", Book2));

            catalog["cardiovascular"] = Entries(
                E("heartChambers", "c9d5c770b3ddb5014230220f12028905df9b896e", Base2 + "19-1-heart-anatomy", "Figure 19.9, Internal Structures of the Heart", Book2),
                E("heartValves", "ff0ff7b063895b5e36b4b72f9c29a120c825578f", Base2 + "19-1-heart-anatomy", "Figure 19.12, Heart Valves", Book2),
                E("arteries", "8b43899d27f37826ddbe8c7616ef67a25e5a625c", Base2 + "20-1-structure-and-function-of-blood-vessels", "Figure 20.3, Structure of Blood Vessels", Book2),
                E("veins", "28fdb799ddce54b0d796cd60508c3daf4ad930f4", Base2 + "20-1-structure-and-function-of-blood-vessels", "Figure 20.7, Comparison of Veins and Venules", Book2),
                E("bloodComponents", "7fa48eed7793f19b4120a18fbd89b434fe2d1274", Base2 + "18-1-an-overview-of-blood", "Figure 18.2, Composition of Blood", Book2),
                E("bloodTypes", "10506feb0f2ee02f5a0821d51cf014c8316939ba", Base2 + "18-3-human-blood-types", "Figure 18.17, ABO Blood Group", Book2),
                E("circulation", "8b8b0fbc51634078bbcf93b75762143a4a80cd47", Base2 + "20-2-blood-flow-blood-pressure-and-resistance", "Figure 20.2, Major Blood Vessels of the Systemic and Pulmonary Circulations", Book2));
            return catalog;
        }

        private static KeyValuePair<string, Illustration> E(string key, string imageId, string sourceUrl, string caption, string book)
        {
            return new KeyValuePair<string, Illustration>(key, new Illustration(imageId, sourceUrl, caption + " — OpenStax " + book));
        }

        private static IDictionary<string, Illustration> Entries(params KeyValuePair<string, Illustration>[] entries)
        {
            var result = new Dictionary<string, Illustration>(StringComparer.OrdinalIgnoreCase);
            foreach (var entry in entries) result.Add(entry.Key, entry.Value);
            return result;
        }

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "application/json";
            context.Response.Cache.SetCacheability(HttpCacheability.NoCache);
            string system = (context.Request.QueryString["system"] ?? string.Empty).Trim();
            string structure = (context.Request.QueryString["structure"] ?? string.Empty).Trim();
            IDictionary<string, Illustration> structures;
            Illustration item;
            if (!Catalog.TryGetValue(system, out structures) || !structures.TryGetValue(structure, out item))
            {
                WriteJson(context, new { found = false, message = "No curated illustration is configured for this structure." });
                return;
            }

            WriteJson(context, new
            {
                found = true,
                imageUrl = item.ImageUrl,
                sourceUrl = item.SourceUrl,
                sourceName = item.Caption,
                artist = "",
                license = License
            });
        }

        private static void WriteJson(HttpContext context, object value)
        {
            context.Response.Write(new JavaScriptSerializer().Serialize(value));
        }

        public bool IsReusable { get { return true; } }
    }
}
