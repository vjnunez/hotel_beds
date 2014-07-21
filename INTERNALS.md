# Grouping results

The process we use to group results is as follows:

1) Group the available rooms (AR) by occupants (OK)
2) Expand the rooms (AR) in the array to illustrate the availability of each room (limit to a max of 5, as we don't support searches of more than 5 rooms)
3) Group the count of each requested room (RC) by occupants (OK)
4) For each group, determine all combinations of the available rooms (AR) for the given count (RC), this gives us the search results per room group (RSRG)
5) Find all combinations of the search results per room group, giving us unique search results (SR)
