using Newtonsoft.Json;

namespace BSMS.BusinessLayer.Services
{
    public class UserInfo
    {
        [JsonProperty("sub")]
        public string Sub { get; set; } = null!;

        [JsonProperty("pronoun")]
        public string PronounName { get; set; } = null!;

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

        [JsonProperty("city")]
        public string CityName { get; set; } = null!;

        [JsonProperty("address_street")]
        public string AddressStreet { get; set; } = null!;

        [JsonProperty("address_building")]
        public string AddressBuilding { get; set; } = null!;

        [JsonProperty("address_floor")]
        public int AddressFloor { get; set; }

        [JsonProperty("address_notes")]
        public string? AddressNotes { get; set; }
    }
}
