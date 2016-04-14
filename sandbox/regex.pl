#!/usr/bin/env perl

use Data::Dumper;

my $datetime = "We'repleasedtobeworkingwithRMITLINK'sOrientationteamandRUSUtowelcomeallnewstudentstocampusthroughaseriesofexcitingOrientationevents.Thisemailservesasanotificationtomakesureyouknowwhenthemajoreventsareoccurring,toensuretheydon'tinterruptyourworkandsothatyouareabletoencourageallnewstudentstoattend.BrunswickAllStudentsWelcome,23February12:30-1:30pmBrunswickCourtyard.BundooraAllStudentsWelcome,24February12-2pmBundooraWestconcourse.CityAllStudentsWelcome,25February11am-2:30pmAlumniCourtyard,UniversityWay.RUSUWelcomeBash,25February4pm-9pmAlumniCourtyard.CityClubsDay,3March11am-2pmAlumniCourtyard,UniversityWay.Earlynextweekisgoodforus.HowaboutMonday11am?Earlynextweekisgoodforus.HowaboutTuesday11:30AM?Earlynextweekisgoodforus.HowaboutWed.11:30AM?Papersubmissiondeadline:January31,2016.Notificationofacceptance:March15th,2016.Finalpapersubmissionandearlyregistrationdeadli
ne:Apr.15,2016Papersubmissiondeadline:31January,2016.Notificationofacceptance:15thMarch,2016.Finalpapersubmissionandearlyregistrationdeadline:15t
hApr.,2016Yes,tomorrow6:00pmisfineforme.Yes,tomorrow6:00pmisfineforme.ThepartywillbeholdonTomorrow9:00pm-2:00am";

my ($matches) = $datetime =~ /(\d{1,2})t?h?(january|jan|february|feb|march|mar|april|apr|may|june|jun|july|jul|august|aug|september|sept|sep|october|oct|november|nov|december|dec)(\d{1,2})(am|pm)?:?(\d{2})?-t?o?(\d{1,2}):?(\d{2})?(am|pm)?/gi;

for my $item($matches){
  print $1;
}

# print Dumper %hash;
