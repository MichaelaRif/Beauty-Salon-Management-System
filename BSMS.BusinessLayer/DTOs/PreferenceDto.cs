namespace BSMS.BusinessLayer.DTOs
{
    public class PreferenceDto
    {
        public string PreferenceName { get; set; } = null!;
        public string PreferenceDescription { get; set; } = null!;
        public CategoryDto Category { get; set; } = null!;
    }

}

