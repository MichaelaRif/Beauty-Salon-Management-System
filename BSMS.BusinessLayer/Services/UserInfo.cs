using Newtonsoft.Json;

namespace BSMS.BusinessLayer.Services
{
    public class UserInfo
    {
        [JsonProperty("sub")]
        public string Sub { get; set; } = null!;

        [JsonProperty("promotions")]
        public bool Promotions { get; set; }

        [JsonProperty("pronoun")]
        public string Pronoun { get; set; } = null!;

        [JsonProperty("date_of_birth")]
        public DateOnly DateOfBirth { get; set; }

        [JsonProperty("phone_number")]
        public string PhoneNumber { get; set; } = null!;

        [JsonProperty("given_name")]
        public string GivenName { get; set; } = null!;

        [JsonProperty("family_name")]
        public string FamilyName { get; set; } = null!;

        [JsonProperty("email")]
        public string Email { get; set; } = null!;
    }
}
