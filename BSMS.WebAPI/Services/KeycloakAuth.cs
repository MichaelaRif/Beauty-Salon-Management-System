using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.IdentityModel.Tokens;
using Newtonsoft.Json;
using System.Security.Claims;

namespace BSMS.WebAPI.Services
{
    public static class KeycloakAuth
    {
        public static IServiceCollection AddKeycloakAuth(this IServiceCollection services, string authority, string clientId)
        {
            services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
                .AddJwtBearer(options =>
                {
                    options.Authority = authority;
                    options.Audience = clientId;
                    options.RequireHttpsMetadata = false;
                    options.TokenValidationParameters = new TokenValidationParameters
                    {
                        ValidateIssuer = true,
                        ValidIssuer = authority,
                        ValidateAudience = false,
                        ValidAudience = clientId,
                        RoleClaimType = ClaimTypes.Role
                    };

                    options.Events = new JwtBearerEvents
                    {
                        OnTokenValidated = context =>
                            AddKeycloakRoles(context, clientId)
                    };
                });

            return services;
        }

        private static Task AddKeycloakRoles(TokenValidatedContext context, string clientId)
        {
            var claims = new List<Claim>();

            claims.AddRange(GetRealmRoles(context));
            claims.AddRange(GetClientRoles(context, clientId));

            if (claims.Any())
            {
                context.Principal?.AddIdentity(new ClaimsIdentity(claims));
            }

            return Task.CompletedTask;
        }

        private static IEnumerable<Claim> GetRealmRoles(TokenValidatedContext context)
        {
            var realmRolesJson = context.Principal?.FindFirst("realm_access")?.Value;
            if (string.IsNullOrEmpty(realmRolesJson)) return Enumerable.Empty<Claim>();

            try
            {
                var realmAccess = JsonConvert.DeserializeObject<Dictionary<string, List<string>>>(realmRolesJson);
                return realmAccess?.GetValueOrDefault("roles", new List<string>())
                       .Select(role => new Claim(ClaimTypes.Role, role))
                       ?? Enumerable.Empty<Claim>();
            }
            catch
            {
                return Enumerable.Empty<Claim>();
            }
        }

        private static IEnumerable<Claim> GetClientRoles(TokenValidatedContext context, string clientId)
        {
            var resourceRolesJson = context.Principal?.FindFirst("resource_access")?.Value;
            if (string.IsNullOrEmpty(resourceRolesJson)) return Enumerable.Empty<Claim>();

            try
            {
                var resourceAccess = JsonConvert.DeserializeObject<Dictionary<string, Dictionary<string, List<string>>>>(resourceRolesJson);
                return resourceAccess?.GetValueOrDefault(clientId, new Dictionary<string, List<string>>())
                       .GetValueOrDefault("roles", new List<string>())
                       .Select(role => new Claim(ClaimTypes.Role, role))
                       ?? Enumerable.Empty<Claim>();
            }
            catch
            {
                return Enumerable.Empty<Claim>();
            }
        }
    }
}
