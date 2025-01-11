using AutoMapper;
using BSMS.BusinessLayer.DTOs;
using BSMS.BusinessLayer.Services;
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

            CreateMap<Country, CountryDto>()
                .ReverseMap();

            CreateMap<Address, AddressDto>()
                .ReverseMap();

            CreateMap<Customer, CustomerDto>()
                .ForMember(dest => dest.PronounName, opt => opt.MapFrom(src => src.CustomerPronoun.Pronoun1))
                .ReverseMap();

            CreateMap<Customer, UserInfo>()
                .ForMember(dest => dest.Sub, opt => opt.MapFrom(src => src.CustomerKeycloakId))
                .ForMember(dest => dest.PronounName, opt => opt.MapFrom(src => src.CustomerPronoun.Pronoun1))
                .ForMember(dest => dest.DateOfBirth, opt => opt.MapFrom(src => src.CustomerDob))
                .ForMember(dest => dest.PhoneNumber, opt => opt.MapFrom(src => src.CustomerPn))
                .ForMember(dest => dest.GivenName, opt => opt.MapFrom(src => src.CustomerFn))
                .ForMember(dest => dest.FamilyName, opt => opt.MapFrom(src => src.CustomerLn))
                .ForMember(dest => dest.Email, opt => opt.MapFrom(src => src.CustomerEmail))
                .ReverseMap();

            CreateMap<CustomerDto, UserInfo>()
                .ForMember(dest => dest.PronounName, opt => opt.MapFrom(src => src.PronounName))
                .ForMember(dest => dest.DateOfBirth, opt => opt.MapFrom(src => src.CustomerDob))
                .ForMember(dest => dest.PhoneNumber, opt => opt.MapFrom(src => src.CustomerPn))
                .ForMember(dest => dest.GivenName, opt => opt.MapFrom(src => src.CustomerFn))
                .ForMember(dest => dest.FamilyName, opt => opt.MapFrom(src => src.CustomerLn))
                .ForMember(dest => dest.Email, opt => opt.MapFrom(src => src.CustomerEmail))
                .ReverseMap();

            CreateMap<Address, UserInfo>()
                .ForMember(dest => dest.CityName, opt => opt.MapFrom(src => src.AddressCity.CityName))
                .ForMember(dest => dest.AddressStreet, opt => opt.MapFrom(src => src.AddressStreet))
                .ForMember(dest => dest.AddressBuilding, opt => opt.MapFrom(src => src.AddressBuilding))
                .ForMember(dest => dest.AddressFloor, opt => opt.MapFrom(src => src.AddressFloor))
                .ForMember(dest => dest.AddressNotes, opt => opt.MapFrom(src => src.AddressNotes))
                .ReverseMap();

            CreateMap<CustomerInfoDto, UserInfo>()
                .ForMember(dest => dest.PronounName, opt => opt.MapFrom(src => src.Customer.PronounName))
                .ForMember(dest => dest.DateOfBirth, opt => opt.MapFrom(src => src.Customer.CustomerDob))
                .ForMember(dest => dest.PhoneNumber, opt => opt.MapFrom(src => src.Customer.CustomerPn))
                .ForMember(dest => dest.GivenName, opt => opt.MapFrom(src => src.Customer.CustomerFn))
                .ForMember(dest => dest.FamilyName, opt => opt.MapFrom(src => src.Customer.CustomerLn))
                .ForMember(dest => dest.Email, opt => opt.MapFrom(src => src.Customer.CustomerEmail))
                .ForMember(dest => dest.CityName, opt => opt.MapFrom(src => src.Address.AddressCity))
                .ForMember(dest => dest.AddressStreet, opt => opt.MapFrom(src => src.Address.AddressStreet))
                .ForMember(dest => dest.AddressBuilding, opt => opt.MapFrom(src => src.Address.AddressBuilding))
                .ForMember(dest => dest.AddressFloor, opt => opt.MapFrom(src => src.Address.AddressFloor))
                .ForMember(dest => dest.AddressNotes, opt => opt.MapFrom(src => src.Address.AddressNotes))
                .ReverseMap();

            CreateMap<Pronoun, PronounDto>()
                .ReverseMap();

            CreateMap<Category, CategoryDto>()
                .ReverseMap();

            CreateMap<Preference, PreferenceDto>()
                .ForMember(dest => dest.CategoryName, opt => opt.MapFrom(src => src.Category.CategoryName))
                .ReverseMap();

        }
    }

}
