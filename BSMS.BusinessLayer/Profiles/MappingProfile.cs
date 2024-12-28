using AutoMapper;
using BSMS.BusinessLayer.DTOs;
using BSMS.Domain.Entities;

namespace BSMS.BusinessLayer.Profiles
{
    public class MappingProfile : Profile
    {
        public MappingProfile()
        {
            CreateMap<City, CityDto>()
                .ReverseMap();


            CreateMap<Bundle, BundleDto>()
                           .ReverseMap();

            CreateMap<Country, CountryDto>().ReverseMap();

            CreateMap<Address, AddressDto>()
                .ReverseMap();


            CreateMap<Customer, CustomerDto>()
                .ReverseMap();

            CreateMap<Pronoun, PronounDto>()
                .ReverseMap();

            CreateMap<Category, CategoryDto>()
                .ReverseMap();

            CreateMap<Preference, PreferenceDto>()
                .ReverseMap();

        }
    }

}
