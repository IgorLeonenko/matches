<template>
  <div id='tournament'>
    <div>
      <div class='left'>
        <router-link :to="{name: 'tournamentInfo', params: {id: $route.params.id}}"
                     v-bind:class="{active: $route.name == 'tournamentInfo'}">
          Info
        </router-link>
        <router-link :to="{name: 'tournamentTeams', params: {id: $route.params.id}}"
                     v-bind:class="{active: $route.name == 'tournamentTeams'}">
          Teams
        </router-link>
        <router-link :to="{name: 'tournamentMatches', params: {id: $route.params.id}}"
                     v-bind:class="{active: $route.name == 'tournamentMatches'}">
          Matches
        </router-link>
        <info v-if="$route.name == 'Tournament'"></info>
        <router-view></router-view>
        <button type='button' @click="goBack()">Back</button>
      </div>
    </div>
  </div>
</template>

<script>
  import { router } from '../main'
  import Info from './TournamentInfo'
  export default {
    name: 'Tournament',
    components: {
      Info
    },
    methods: {
      goBack () {
        router.push('/tournaments')
      }
    }
  }
</script>

<style scoped>
  #tournament {
    text-align: left;
    width: 70%;
    margin: 0 auto;
  }
  ul {
    list-style: none;
  }
  .left {
    float: left;
  }
  .active {
    color: green;
  }
</style>
